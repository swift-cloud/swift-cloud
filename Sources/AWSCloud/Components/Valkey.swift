import Foundation

extension AWS {
    public struct Valkey: AWSComponent {
        public let cache: Resource

        public var name: Output<String> {
            cache.name
        }

        public var readWriteUrl: Output<String> {
            let address = cache.output.keyPath("endpoints[0].address")
            let port = cache.output.keyPath("endpoints[0].port")
            return "redis://\(address):\(port)"
        }

        public var readUrl: Output<String> {
            let address = cache.output.keyPath("readerEndpoints[0].address")
            let port = cache.output.keyPath("readerEndpoints[0].port")
            return "redis://\(address):\(port)"
        }

        public init(
            _ name: String,
            vpc: VPC,
            options: Resource.Options? = nil
        ) {
            cache = Resource(
                name: name,
                type: "aws:elasticache:ServerlessCache",
                properties: [
                    "engine": "valkey",
                    "majorEngineVersion": "8",
                    "securityGroupIds": [vpc.defaultSecurityGroup.id],
                    "subnetIds": vpc.privateSubnetIds,
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
            "valkey \(cache.chosenName) url": self.readWriteUrl
        ]
    }
}
