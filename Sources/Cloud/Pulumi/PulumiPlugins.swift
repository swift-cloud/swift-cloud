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
        version: "6.48.0",
        repo: "pulumi/pulumi-aws"
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

    public static let digitalocean = Pulumi.Plugin(
        name: "digitalocean",
        version: "4.31.0",
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

    public static let planetscale = Pulumi.Plugin(
        name: "planetscale",
        version: "0.0.7",
        repo: "sst/pulumi-planetscale"
    )

    public static let vercel = Pulumi.Plugin(
        name: "vercel",
        version: "1.11.0",
        repo: "pulumiverse/pulumi-vercel"
    )
}
