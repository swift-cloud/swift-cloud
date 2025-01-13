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
            engine: Engine = .valkey(),
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
                options: options,
                maxNameLength: 32
            )
        }
    }
}

extension AWS.Cache {
    public enum Engine: Sendable {
        case valkey(_ version: ValkeyVersion = .v8)
        case redis(_ version: RedisVersion = .v7)
        case memcached(_ version: MemcachedVersion = .v1_6)

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
                return "rediss"
            case .memcached:
                return "memcached"
            }
        }

        var version: String {
            switch self {
            case .valkey(let version):
                return version.rawValue
            case .redis(let version):
                return version.rawValue
            case .memcached(let version):
                return version.rawValue
            }
        }
    }

    public enum ValkeyVersion: String, Sendable {
        case v8 = "8"
        case v7 = "7"
    }

    public enum RedisVersion: String, Sendable {
        case v7 = "7"
    }

    public enum MemcachedVersion: String, Sendable {
        case v1_6 = "1.6"
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

    public var properties: LinkProperties? {
        return .init(
            type: "cache",
            name: cache.chosenName,
            properties: [
                "hostname": hostname,
                "port": port,
                "url": url,
            ]
        )
    }
}
