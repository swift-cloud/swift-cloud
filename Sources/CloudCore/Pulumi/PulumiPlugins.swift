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
        version: "6.65.0",
        repo: "pulumi/pulumi-aws"
    )

    // https://github.com/pulumi/pulumi-awsx
    public static let awsx = Pulumi.Plugin(
        name: "awsx",
        version: "2.19.0",
        repo: "pulumi/pulumi-awsx"
    )

    // https://github.com/pulumi/pulumi-cloudflare
    public static let cloudflare = Pulumi.Plugin(
        name: "cloudflare",
        version: "5.46.0",
        repo: "pulumi/pulumi-cloudflare"
    )

    // https://github.com/pulumi/pulumi-fastly
    public static let fastly = Pulumi.Plugin(
        name: "fastly",
        version: "8.13.0",
        repo: "pulumi/pulumi-fastly"
    )

    // https://github.com/pulumi/pulumi-random
    public static let random = Pulumi.Plugin(
        name: "random",
        version: "4.16.8",
        repo: "pulumi/pulumi-random"
    )
}
