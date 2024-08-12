# Swift Cloud

The fastest way to build and deploy server side Swift applications.

```swift
AWS.WebServer(
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

#### Setup Docker

In order to use Swift Cloud you need to have Docker installed on your machine. This is a short term limitation until Swift 6 where we will be able to natively cross-compile to Linux and other SDKs.

If you're on a Mac the easiest way to install Docker is [OrbStack](https://orbstack.dev). Simply download OrbStack and run the installer.

#### Setup AWS

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

### Add to your project

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

Next, inside your `Sources` directory create a new folder called `Infra`.

Finally, add a new Swift file called `Project.swift`:

```swift
import Cloud

@main
struct SwiftCloudDemo: Project {
    func build() async throws -> Outputs {
        let server = AWS.WebServer(
            "my-vapor-web-server",
            targetName: "App",
            concurrency: 1,
            autoScaling: .init(
                maximumConcurrency: 10,
                metrics: [.cpu(50), .memory(50)]
            )
        )

        return Outputs([
            "url": "http://\(server.hostname)",
        ])
    }
}
```

### Deploy your project

```bash
swift run Infra deploy --stage production
```

## Commands

Swift Cloud is invoked directly from your Swift package. You can run the following commands:

### Deploy

Deploy your infrastructure:

```bash
swift run Infra deploy --stage production
```

### Remove

Remove all resources:

```bash
swift run Infra remove --stage development
```

### Preview

Preview changes before deploying:

```bash
swift run Infra preview --stage development
```

### Cancel

Cancel a deployment:

```bash
swift run Infra cancel --stage development
```

## Home

Swift Cloud allows you to deploy infrastructure across multiple cloud providers. In order to handle incremental changes to your infrastructure, Swift Cloud must store your underlying configuration in a durable location so it can be referenced anytime you run a deploy, whether from your local machine or a CI/CD pipeline.

We abstracted this concept into a `HomeProvider` protocol, and allow you to decide where your configuration is stored. By default, Swift Cloud uses the AWS S3 service to store your configuration, but you can easily swap this out for any other provider that supports the `HomeProvider` protocol.

For quick prototyping, you can use the `Home.Local` provider, which stores your configuration in a local file. This is great for testing and development, but it's not recommended for production use.

```swift
import Cloud

@main
struct SwiftCloudDemo: Project {

    // Override the default home provider with a local provider
    let home = Home.Local()

    func build() async throws -> Outputs {...}
}
```

## Components

### AWS

#### WebServer

This component creates a high performance web server using an application load balancer, auto-scaling group, and Fargate. Everything is fully managed and scales automatically based on your configuration.

```swift
let server = AWS.WebServer(
    "my-vapor-web-server",
    targetName: "App",
    concurrency: 1,
    autoScaling: .init(
        maximumConcurrency: 10,
        metrics: [.cpu(50), .memory(50)]
    )
)
```

#### Function

```swift
let lambda = AWS.Function(
    "my-lambda-function",
    targetName: "App",
    url: .enabled(cors: true),
    memory: 512,
    timeout: .seconds(10)
)
```

#### Bucket

```swift
let bucket = AWS.Bucket("my-s3-bucket")
```

#### Queue

```swift
let queue = AWS.Queue("my-sqs-queue")

// Subscribe a lambda function to the queue to process messages
queue.subscribe(
    AWS.Function("my-lambda-function", targetName: "App")
)
```

#### Cron

```swift
let cron = AWS.Cron(
    "my-cron-job",
    schedule: .rate(.minutes(5))
)

// Invoke the function when the cron job runs
cron.invoke(
    AWS.Function("my-lambda-function", targetName: "App")
)
```

### Linking

You can link resources together to provide the necessary permissions to access each other. This is more secure than sharing access key ids and secrets in environment variables.

For example you can link an S3 bucket to a Lambda function:

```swift
myFunction.link(bucket)
```

This allows the lambda function to access the bucket without needing to share access keys.

#### Using linked resources

You can use linked resources in your server or function via environment variables in your application:

```swift
let bucketUrl = ProcessInfo.processInfo.environment["bucket:my-bucket:url"]
```

Here is a list of all the linked resources:

| Resource | Environment Variable |
| --- | --- |
| AWS S3 Bucket | `bucket:<bucket-name>:url` |
| AWS S3 Bucket | `bucket:<bucket-name>:hostname` |
| AWS S3 Bucket | `bucket:<bucket-name>:name` |
| AWS SQS Queue | `queue:<queue-name>:url` |
| AWS SQS Queue | `queue:<queue-name>:name` |
| AWS Lambda Function | `function:<function-name>:url` |
| AWS Lambda Function | `function:<function-name>:name` |
