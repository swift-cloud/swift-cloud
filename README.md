# Swift Cloud

Deploy server-side Swift applications to the cloud with ease.

## Get Started

### Add Swift Cloud to your project

```swift
dependencies: [
    .package(url: "https://github.com/swift-cloud/swift-cloud.git", branch: "main")
]
```

### Create a new project

Start by defining a new executable target in your `Package.swift` file:

```swift
targets: [
    .executableTarget(
        name: "Infra",
        dependencies: [.product(name: "Cloud", package: "swift-cloud")]
    )
]
```

Then inside your `Sources` directory create a new folder called `Infra` and add a new Swift file called `Project.swift`:

```swift
import Cloud

@main
struct SwiftCloudDemo: Project {
    func build() async throws -> Outputs {
        let bucket = aws.Bucket("assets")

        let function = aws.Function("hello-swift", targetName: "App")

        return Outputs([
            "bucketName": bucket.name,
            "bucketUrl": "https://\(bucket.hostname)",
            "functionUrl": function.url,
        ])
    }
}
```

### Deploy your project

```bash
swift run Infra deploy --stage production
```
