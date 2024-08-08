# Swift Cloud

Deploy server-side Swift applications to the cloud with ease.

```swift
aws.WebServer(
    "my-vapor-app",
    targetName: "App",
    concurrency: 1,
    autoScaling: .init(
        maximumConcurrency: 10,
        metrics: [.cpu(50), .memory(50)]
    )
)
```

## Get Started

### Prepare your environment

#### Docker

In order to use Swift Cloud you need to have Docker installed on your machine. This is a short term limitation until Swift 6 where we will be able to natively cross-compile to Linux and other SDKs.

If you're on a Mac the easiest way to install Docker is [OrbStack](https://orbstack.dev). Simply download OrbStack and run the installer.

#### AWS

Today, Swift Cloud only supports AWS. You will need to have an AWS account and AWS credentials loaded on your machine or in the typical environment variables.

```bash
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
```

If you're on a Mac the easiest way to manage your AWS credentials is [Leapp](https://www.leapp.cloud).

You can also use the AWS CLI to configure your credentials:

```bash
aws configure
```

### Add Swift Cloud to your project

```swift
dependencies: [
    .package(url: "https://github.com/swift-cloud/swift-cloud.git", branch: "main")
]
```

### Define your infrastructure

Swift Cloud works by declaring your infrastructure as Swift code. To do this you must create a new executable target in the same package as your application.

Start by defining a new executable target in your `Package.swift` file:

```swift
targets: [
    ...
    .executableTarget(
        name: "Infra",
        dependencies: [
            .product(name: "Cloud", package: "swift-cloud")
        ]
    )
]
```

Then inside your `Sources` directory create a new folder called `Infra` and add a new Swift file called `Project.swift`:

```swift
import Cloud

@main
struct SwiftCloudDemo: Project {
    func build() async throws -> Outputs {
        let server = aws.WebServer(
            "my-vapor-web-server",
            targetName: "App",
            concurrency: 1,
            autoScaling: .init(
                maximumConcurrency: 10,
                metrics: [.cpu(50), .memory(50)]
            )
        )

        return Outputs([
            "url": "http://\\(server.hostname)",
        ])
    }
}
```

### Deploy your project

```bash
swift run Infra deploy --stage production
```
