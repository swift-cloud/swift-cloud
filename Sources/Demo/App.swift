import Cloud

@main
struct Demo: Project {
    func build() async throws -> Outputs {
        let bucket = aws.Bucket("My New Bucket")

        let function = aws.Function(
            "My Function",
            targetName: "Demo"
        )

        let queue = aws.Queue("My Queue").subscribe(function)

        function.link(queue)

        return Outputs([
            "bucketName": bucket.name,
            "bucketUrl": "https://\(bucket.hostname)",
            "functionUrl": function.url,
            "queueUrl": queue.url,
        ])
    }
}
