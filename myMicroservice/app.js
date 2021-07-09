import { app, query, sparqlEscapeUri } from 'mu';

import bodyParser from 'body-parser';


function predicateToField(predicate) {
  const { value, type } = predicate;
  if (type !== "uri") {
    console.error(`Got strange type '${type}'`)
    return;
  }

  for (let base of ["http://schema.org/"]) {
    const uri_start = value.indexOf(base);
    if (uri_start >= 0) {
      return value.slice(uri_start + base.length);
    }
  }
  console.log(`Could not determine field '${value}'`);
}

function objectToValue(object) {
  const { value, type } = object;
  if (type === "literal" && object.datatype === "http://www.w3.org/2001/XMLSchema#decimal") {
    return parseInt(value);
  }
  return value;
}

const build_dict = {};
const ws_connections = {};

var WS_CONNECTION_ID = 0;

app.use(bodyParser.json({
  type: function (req) {
    return /^application\/json/.test(req.get('content-type'));
  },
  limit: '500mb'
}));

app.get('/', function (req, res) {
  res.send(JSON.stringify(req.headers));
});

app.get('/query', function (req, res) {
  var myQuery = `
    PREFIX session: <http://mu.semte.ch/vocabularies/session/>
    PREFIX sh: <http://schema.org/>
    SELECT DISTINCT ?o WHERE {
        ${sparqlEscapeUri(req.headers["mu-session-id"])} session:account ?o.
    }`;

  console.log(myQuery);

  query(myQuery)
    .then(function (response) {
      res.send(JSON.stringify(response));
    })
    .catch(function (err) {
      res.send("Oops something went wrong: " + JSON.stringify(err));
    });
});


const tag_list = [
  { fields: ["fromx", "fromy", "tox", "toy", "index", "gameid"], tag: "move" },
  // Add player game register
  { fields: ["gameid", "playerid"], tag: "player_register" },
];

function addInsert(changed, insert) {
  const { subject, predicate, object } = insert;
  const s = subject.value
  changed.add(s);

  const p = predicateToField(predicate);
  const o = objectToValue(object);
  if (!build_dict[s]) build_dict[s] = {};

  if (p) {
    build_dict[s][p] = o;
  }
}

function checkFinished(s) {
  const obj = build_dict[s];
  for (let tag of tag_list) {
    let good = true;
    for (let field of tag.fields) { // Check if all fields are present
      if (!obj.hasOwnProperty(field)) {
        good = false;
        break;
      }
    }

    if (good) { // All fields are present for this tag
      broadcast(obj, tag.tag);
      delete build_dict[s];
      break;
    }
  }
}


app.post("/delta", (req, res) => {
  console.log('Delta body:', JSON.stringify(req.body));

  for (let delta of req.body) {
    const changed = new Set();

    for (let insert of delta.inserts)
      addInsert(changed, insert)

    for (let remove of delta.deletes) {
      console.error("unhandled delete delta", remove);
    }

    for (let s of changed) {
      checkFinished(s);
    }
  }

  res.sendStatus(200);
});

function broadcast(action, tag) {
  // todo
  console.log("broadcasting", action, tag);
  for(let id in ws_connections)
  {
    console.log("ws id", id);
    ws_connections[id].send(JSON.stringify({tag, action}));
  }
}

const WebSocket = require('ws');

const wss = new WebSocket.Server({ port: 8080 });


wss.on('connection', function connection(ws) {
  const ws_conn = WS_CONNECTION_ID;
  WS_CONNECTION_ID++;

  ws_connections[ws_conn] = ws;

  ws.on("close", () => delete ws_connections[ws_conn]);

  ws.on('message', function incoming(message) {
    console.log('received (strange): %s', message);
  });

  console.log("Got ws connections!");
});
