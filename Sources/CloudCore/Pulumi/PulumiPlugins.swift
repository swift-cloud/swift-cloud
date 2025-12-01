extension Pulumi {
    public struct Plugin: Sendable {
        public let name: String
        public let version: String
        public let repo: String

        public var server: String {
            "https://github.com/\(repo)/releases/download/v\(version)/"
        }

        public init(name: String, version: String, repo: String) {
            self.name = name
            self.version = version
            self.repo = repo
        }
    }
}

extension Pulumi.Plugin {
    // https://github.com/pulumi/pulumi-aws
    public static let aws = Pulumi.Plugin(
        name: "aws",
        version: "7.12.0",
        repo: "pulumi/pulumi-aws"
    )

    // https://github.com/pulumi/pulumi-awsx
    public static let awsx = Pulumi.Plugin(
        name: "awsx",
        version: "3.1.0",
        repo: "pulumi/pulumi-awsx"
    )

    // https://github.com/pulumi/pulumi-cloudflare
    public static let cloudflare = Pulumi.Plugin(
        name: "cloudflare",
        version: "6.11.0",
        repo: "pulumi/pulumi-cloudflare"
    )

    // https://github.com/pulumi/pulumi-digitalocean
    public static let digitalocean = Pulumi.Plugin(
        name: "digitalocean",
        version: "4.55.0",
        repo: "pulumi/pulumi-digitalocean"
    )

    // https://github.com/pulumi/pulumi-fastly
    public static let fastly = Pulumi.Plugin(
        name: "fastly",
        version: "11.2.0",
        repo: "pulumi/pulumi-fastly"
    )

    // https://github.com/pulumi/pulumi-random
    public static let random = Pulumi.Plugin(
        name: "random",
        version: "4.18.4",
        repo: "pulumi/pulumi-random"
    )

    // https://github.com/pulumiverse/pulumi-vercel
    public static let vercel = Pulumi.Plugin(
        name: "vercel",
        version: "3.15.1",
        repo: "pulumiverse/pulumi-vercel"
    )
}
