import Cloud

@main
struct Example: Project {
    func build() async throws -> Outputs {
        let server = AWS.WebServer(
            "My Server",
            targetName: "Example",
            domainName: .init(
                domainName: "demo.aws.swift.cloud",
                zoneName: "aws.swift.cloud"
            )
        )

        return Outputs([
            "url": server.url
        ])
    }
}
