import Cloud

@main
struct Demo: Project {
    func build() async throws -> Outputs {
        let function = aws.Function(
            "My Function",
            targetName: "Demo"
        )
        return Outputs([
            "functionUrl": function.url
        ])
    }
}
