extension Pulumi {
    public struct Plugin: Sendable {
        public let name: String
        public let version: String
        public let repo: String

        public var server: String {
            "https://github.com/\(repo)/releases/download/v\(version)/"
        }
    }
}

extension Pulumi.Plugin {
    public static let aws = Pulumi.Plugin(
        name: "aws",
        version: "6.54.0",
        repo: "pulumi/pulumi-aws"
    )

    public static let awsx = Pulumi.Plugin(
        name: "awsx",
        version: "2.16.0",
        repo: "pulumi/pulumi-awsx"
    )

    public static let awsNative = Pulumi.Plugin(
        name: "aws-native",
        version: "0.114.0",
        repo: "pulumi/pulumi-aws-native"
    )

    public static let azure = Pulumi.Plugin(
        name: "azure",
        version: "5.86.0",
        repo: "pulumi/pulumi-azure"
    )

    public static let cloudflare = Pulumi.Plugin(
        name: "cloudflare",
        version: "5.35.1",
        repo: "pulumi/pulumi-cloudflare"
    )

    public static let digitalOcean = Pulumi.Plugin(
        name: "digitalocean",
        version: "4.34.0",
        repo: "pulumi/pulumi-digitalocean"
    )

    public static let fastly = Pulumi.Plugin(
        name: "fastly",
        version: "8.9.0",
        repo: "pulumi/pulumi-fastly"
    )

    public static let gcp = Pulumi.Plugin(
        name: "gcp",
        version: "7.34.0",
        repo: "pulumi/pulumi-gcp"
    )

    public static let heroku = Pulumi.Plugin(
        name: "heroku",
        version: "1.0.3",
        repo: "pulumiverse/pulumi-heroku"
    )

    public static let planetscale = Pulumi.Plugin(
        name: "planetscale",
        version: "0.0.7",
        repo: "sst/pulumi-planetscale"
    )

    public static let random = Pulumi.Plugin(
        name: "random",
        version: "4.16.3",
        repo: "pulumi/pulumi-random"
    )

    public static let vercel = Pulumi.Plugin(
        name: "vercel",
        version: "1.11.0",
        repo: "pulumiverse/pulumi-vercel"
    )
}
