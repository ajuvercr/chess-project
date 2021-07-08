export default [
    {
        match: {
            graph: { value: "http://mu.semte.ch/public", type: "uri" }
        },
        callback: {
            url: "http://myMicroservice/delta", method: "POST"
        },
        options: {
            resourceFormat: "v0.0.1",
            gracePeriod: 1000,
            ignoreFromSelf: true
        }
    }
]
