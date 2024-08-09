import Cloud

@main
struct Example: Project {
    let home = Home.AWS()

    func build() async throws -> Outputs {
        let function = AWS.Function("My Function", targetName: "Example")

        let bucket = AWS.Bucket("My Bucket")

        function.link(bucket)

        return Outputs([
            "url": function.url
        ])
    }
}
