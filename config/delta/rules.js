export default [
    {
        match: {
            object: {"value":"http://schema.org/Move","type":"uri"}
        },
        callback: {
            url: "http://myMicroservice/delta", method: "POST"
        },
        options: {
            resourceFormat: "v0.0.1",
            gracePeriod: 500,
            ignoreFromSelf: true
        }
    },
    {
        match: {
            predicate: {"value":"http://schema.org/Game","type":"uri"}
        },
        callback: {
            url: "http://myMicroservice/delta", method: "POST"
        },
        options: {
            resourceFormat: "v0.0.1",
            gracePeriod: 500,
            ignoreFromSelf: true
        }
    }
]
