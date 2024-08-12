import Cloud

@main
struct Example: Project {
    let home = Home.AWS()

    let providers: [Provider] = [
        .aws(region: "us-east-1")
    ]

    func build() async throws -> Outputs {
        let function = AWS.Function(
            "My Function",
            targetName: "Example",
            url: .enabled(cors: true)
        )

        let bucket = AWS.Bucket("My Bucket")

        function.link(bucket)

        return Outputs([
            "url": function.url
        ])
    }
}
