import Cloud

@main
struct Example: Project {
    func build() async throws -> Outputs {
        let function = aws.Function("My Function", targetName: "App")

        return Outputs([
            "url": function.url
        ])
    }
}
