import Cloud

@main
struct Example: Project {
    func build() async throws -> Outputs {
        let server = AWS.WebServer(
            "My Server",
            targetName: "Example",
            domainName: .init("demo.aws.swift.cloud")
        )

        let queue = AWS.Queue("my queue")

        let function = AWS.Function("my function", targetName: "App")

        let topic = AWS.Topic("my topic")

        topic.subscribe(function)

        topic.subscribe(queue)

        queue.subscribe(function)

        return Outputs([
            "url": server.url
        ])
    }
}
