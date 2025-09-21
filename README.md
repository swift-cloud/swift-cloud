# Swift Cloud

Swift Infrastructure as Code

The fastest way to build and deploy server side Swift applications.

Swift Cloud is based on the premise that infrastructure should be defined along
side your application, in the same language as your application. In our case,
Swift. Define a new target, describe your infrastructure, and deploy it with a
single command. There's no Dockerfiles, no Terrafrom configurations, no Node.js
packages. Everything is defined in Swift and the complex configuration is
handled behind the scenes, using modern architecture best practices.

```swift
let jobHandler = AWS.Function(
    "job-handler",
    targetName: "JobProcessor",
    memory: 512,
    timeout: .seconds(10)
)

let queue = AWS.Queue("job-queue")

queue.subscribe(jobHandler)

let server = AWS.WebServer(
    "hummingbird-server",
    targetName: "App",
    concurrency: 1,
    autoScaling: .init(
        maximumConcurrency: 10,
        metrics: [.cpu(50), .memory(50)]
    )
)

server.link(queue)
```

```sh
swift run Infra deploy --stage production
```

## How it works

The Swift Cloud package is powered by [Pulumi](https://www.pulumi.com).
Specifically, the SDK vends Swift components that are compiled into Pulumi YAML
files, and then the Pulumi CLI is used to deploy your application. You do not
need a Pulumi account to use Swift Cloud, nor do you need to install Pulumi CLI
on your machine. Everything is managed by the SDK and written to a `.cloud`
directory in your project.

## Get Started

### Prepare your environment

#### Setup Docker

In order to use Swift Cloud you need to have Docker installed on your machine.
This is a short term limitation until Swift 6 where we will be able to natively
cross-compile to Linux and other SDKs.

If you're on a Mac the easiest way to install Docker is
[OrbStack](https://orbstack.dev). Simply download OrbStack and run the
installer.

#### Setup AWS

You will need to have an AWS account and AWS credentials loaded on your machine
or in the typical environment variables.

```bash
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
```

You can also provide a `.env` file in the root of your project with the same
relevant variables.

If you're on a Mac the easiest way to manage your AWS credentials is
[Leapp](https://www.leapp.cloud).

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

Swift Cloud works by declaring your infrastructure as Swift code. To do this you
must create a new executable target in the same package as your application.

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
struct SwiftCloudDemo: AWSProject {
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
            "url": server.url,
        ])
    }
}
```

### Deploy your project

```bash
swift run Infra deploy --stage production
```

## Commands

Swift Cloud is invoked directly from your Swift package. You can run the
following commands:

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

### Outputs

Show the outputs of your deployment:

```bash
swift run Infra outputs --stage development
```

### Cancel

Cancel a deployment:

```bash
swift run Infra cancel --stage development
```

## Home

Swift Cloud allows you to deploy infrastructure across multiple cloud providers.
In order to handle incremental changes to your infrastructure, Swift Cloud must
store your underlying configuration in a durable location so it can be
referenced anytime you run a deploy, whether from your local machine or a CI/CD
pipeline.

We abstracted this concept into a `HomeProvider` protocol, and allow you to
decide where your configuration is stored. By default, Swift Cloud uses the AWS
S3 service to store your configuration, but you can easily swap this out for any
other provider that supports the `HomeProvider` protocol.

For quick prototyping, you can use the `Home.Local` provider, which stores your
configuration in a local file. This is great for testing and development, but
it's not recommended for production use.

```swift
import Cloud

@main
struct SwiftCloudDemo: AWSProject {

    // Override the default home provider with a local provider
    let home = Home.Local()

    func build() async throws -> Outputs {...}
}
```

## Components

### AWS

#### WebServer

This component creates a high performance web server using an application load
balancer, auto-scaling group, and Fargate. Everything is fully managed and
scales automatically based on your configuration.

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

#### CDN

This component creates a CDN that sits in front of your application. It can be
used to cache your application assets, or to serve your application from a
custom domain.

```swift
let cdn = AWS.CDN(
    "my-cdn",
    origins: .webServer(server)
)
```

You can also route traffic on different paths to different resources:

```swift
let cdn = AWS.CDN(
    "my-cdn",
    origins: [
        .function(function, path: "/api/*"),
        .webServer(server, path: "*")
    ]
)
```

And of course you can use a custom domain:

```swift
let cdn = AWS.CDN(
    "my-cdn",
    origins: .function(function),
    domainName: .init("www.example.com")
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

#### DynamoDB

```swift
let table = AWS.DynamoDB(
    "MyTable",
    primaryIndex: .init(
        partitionKey: ("type", .string),
        sortKey: ("id", .string)
    )
)

// Link the table to a function or web server
function.link(table)
```

#### Cache

```swift
let vpc = AWS.VPC("my-vpc")

let cache = AWS.Cache(
    "my-valkey-cache",
    engine: .valkey(), // or .redis() or .memcached()
    vpc: .private(vpc)
)

// Allow the function or web server to connect to the cache
function.link(cache)
```

#### SQL Database

```swift
let database = AWS.SQLDatabase(
    "my-postgres-database",
    engine: .postgres(),
    vpc: .private(vpc)
)

// Allow the function or web server to connect to the database
function.link(database)
```

#### Topic

```swift
let topic = AWS.Topic("my-sns-topic")

// Subscribe a lambda function to the topic to process events
topic.subscribe(
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

#### Domain Name

The `DomainName` construct manages a TLS certificate and the necessary
validation, and can be linked to a `WebServer` to provide a fully managed domain
name.

> [!IMPORTANT]
> SwiftCloud supports 3 providers for domains: **AWS**, **Cloudflare**, and **Vercel**.

```swift
let domainName = DomainName(
    hostname: "www.example.com",
    dns: .aws(zoneName: "example.com")
)

let server = AWS.WebServer(
    "my-vapor-web-server",
    targetName: "App",
    domainName: domainName
)

return Outputs([
    // Now server url will be `https://www.example.com`
    "url": server.url
])
```

### Linking

You can link resources together to provide the necessary permissions to access
each other. This is more secure than sharing access key ids and secrets in
environment variables.

For example you can link an S3 bucket to a Lambda function:

```swift
myFunction.link(bucket)
```

This allows the lambda function to access the bucket without needing to share
access keys.

#### Using linked resources

You can use linked resources in your server or function via environment
variables in your application:

```swift
let bucketUrl = ProcessInfo.processInfo.environment["BUCKET_MEDIA_URL"]
```

Here is a list of all the linked resources:

| Resource            | Environment Variable         |
| ------------------- | ---------------------------- |
| AWS S3 Bucket       | `BUCKET_<NAME>_URL`          |
| AWS S3 Bucket       | `BUCKET_<NAME>_HOSTNAME`     |
| AWS S3 Bucket       | `BUCKET_<NAME>_NAME`         |
| AWS SQS Queue       | `QUEUE_<NAME>_URL`           |
| AWS SQS Queue       | `QUEUE_<NAME>_NAME`          |
| AWS Lambda Function | `FUNCTION_<NAME>_URL`        |
| AWS Lambda Function | `FUNCTION_<NAME>_NAME`       |
| AWS DynamoDB Table  | `DYNAMODB_<NAME>_NAME`       |
| AWS Cache           | `CACHE_<NAME>_HOSTNAME`      |
| AWS Cache           | `CACHE_<NAME>_PORT`          |
| AWS Cache           | `CACHE_<NAME>_URL`           |
| AWS SQL Database    | `SQLDB_<NAME>_HOSTNAME`      |
| AWS SQL Database    | `SQLDB_<NAME>_PORT`          |
| AWS SQL Database    | `SQLDB_<NAME>_DATABASE_NAME` |
| AWS SQL Database    | `SQLDB_<NAME>_USERNAME`      |
| AWS SQL Database    | `SQLDB_<NAME>_PASSWORD`      |
| AWS SQL Database    | `SQLDB_<NAME>_URL`           |
