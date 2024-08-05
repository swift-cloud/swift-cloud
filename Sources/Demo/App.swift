import Cloud

@main
struct App: Project {

    var name: String {
        "swift-cloud-demo"
    }

    func run(context: Context) async throws -> Outputs {
        let bucket = aws.Bucket("My New Bucket")

        let function = aws.Function("My Function", targetName: "Demo")

        return Outputs([
            "bucketName": bucket.bucketName,
            "functionUrl": function.url,
        ])
    }
}
