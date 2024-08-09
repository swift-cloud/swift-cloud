import Cloud

@main
struct Example: Project {
    let home = Home.AWS()

    func build() async throws -> Outputs {
        let function = AWS.Function("My Function", targetName: "Example")

        return Outputs([
            "url": function.url
        ])
    }
}
