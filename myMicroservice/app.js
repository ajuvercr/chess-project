import { app, query, sparqlEscapeUri } from 'mu';

import bodyParser from 'body-parser';

app.use( bodyParser.json( {
    type: function(req) {
      return /^application\/json/.test( req.get('content-type') );
    },
    limit: '500mb'
  } ) );

app.get('/', function (req, res) {
    res.send(JSON.stringify(req.headers));
    // res.send('Hello mu-javascript-templatessss, how you doing\n');
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

app.post("/delta", (req, res) => {
    // console.log('Delta body:', JSON.stringify(req.body));
    // console.log(JSON.stringify(req));
    res.sendStatus(200);
});
