import Cloud

@main
struct Example: Project {
    func build() async throws -> Outputs {
        let server = AWS.WebServer(
            "My Server",
            targetName: "Example",
            domainName: .init("demo.aws.swift.cloud")
        )

        return Outputs([
            "url": server.url
        ])
    }
}
