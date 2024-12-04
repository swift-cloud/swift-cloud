import Foundation

extension AWS {
    public struct Valkey: AWSComponent {
        public let cache: Resource

        public var name: Output<String> {
            cache.name
        }

        public var hostname: Output<String> {
            cache.output.keyPath("endpoints[0].address")
        }

        public var port: Output<String> {
            cache.output.keyPath("endpoints[0].port")
        }

        public var url: Output<String> {
            return "redis://\(hostname):\(port)"
        }

        public init(
            _ name: String,
            vpc: VPC.Configuration,
            options: Resource.Options? = nil
        ) {
            cache = Resource(
                name: name,
                type: "aws:elasticache:ServerlessCache",
                properties: [
                    "engine": "valkey",
                    "majorEngineVersion": "8",
                    "securityGroupIds": vpc.securityGroupIds,
                    "subnetIds": vpc.subnetIds,
                ],
                options: options
            )
        }
    }
}

extension AWS.Valkey: Linkable {
    public var actions: [String] {
        [
            "elasticache:Connect"
        ]
    }

    public var resources: [Output<String>] {
        [cache.arn]
    }

    public var environmentVariables: [String: Output<String>] {
        [
            "valkey \(cache.chosenName) hostname": self.hostname,
            "valkey \(cache.chosenName) port": self.port,
            "valkey \(cache.chosenName) url": self.url,
        ]
    }
}
