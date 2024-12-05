import Foundation

extension AWS {
    public struct Cache: AWSComponent {
        public let engine: Engine

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
            return "\(engine.scheme)://\(hostname):\(port)"
        }

        public init(
            _ name: String,
            engine: Engine = .valkey(version: "8"),
            vpc: VPC.Configuration,
            options: Resource.Options? = nil
        ) {
            self.engine = engine
            cache = Resource(
                name: name,
                type: "aws:elasticache:ServerlessCache",
                properties: [
                    "engine": engine.name,
                    "majorEngineVersion": engine.version,
                    "securityGroupIds": vpc.securityGroupIds,
                    "subnetIds": vpc.subnetIds,
                ],
                options: options
            )
        }
    }
}

extension AWS.Cache {
    public enum Engine: Sendable {
        case valkey(version: String = "8")
        case redis(version: String = "7")
        case memcached(version: String = "1.6")

        public var name: String {
            switch self {
            case .valkey:
                return "valkey"
            case .redis:
                return "redis"
            case .memcached:
                return "memcached"
            }
        }

        public var scheme: String {
            switch self {
            case .valkey, .redis:
                return "redis"
            case .memcached:
                return "memcached"
            }
        }

        var version: String {
            switch self {
            case .valkey(let version):
                return version
            case .redis(let version):
                return version
            case .memcached(let version):
                return version
            }
        }
    }
}

extension AWS.Cache: Linkable {
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
            "cache \(cache.chosenName) hostname": self.hostname,
            "cache \(cache.chosenName) port": self.port,
            "cache \(cache.chosenName) url": self.url,
        ]
    }
}
