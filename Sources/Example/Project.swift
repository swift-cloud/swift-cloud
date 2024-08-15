import Cloud

@main
struct Example: Project {
    func build() async throws -> Outputs {
        let server = AWS.WebServer(
            "My Server",
            targetName: "Example",
            domainName: "hello.swift-cloud.dev"
        )

        return Outputs([
            "url": server.url
        ])
    }
}
