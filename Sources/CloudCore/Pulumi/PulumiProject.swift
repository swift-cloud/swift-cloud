extension Pulumi {
    public struct Project: Encodable {
        public enum Runtime: String, Encodable {
            case yaml
        }

        public struct Backend: Encodable {
            public enum URL: Encodable {
                case local(path: String)
                case s3(bucket: String)

                public func encode(to encoder: any Encoder) throws {
                    var container = encoder.singleValueContainer()
                    switch self {
                    case .local(let path):
                        try container.encode("file://\(path)")
                    case .s3(let bucket):
                        try container.encode("s3://\(bucket)")
                    }
                }
            }
            public var url: URL
        }

        public struct Options: Encodable {
            public enum Refresh: String, Encodable {
                case always
            }
            public var refresh: Refresh?
        }

        public struct Template: Encodable {
            public var displayName: String?
            public var description: String?
            public var config: String
            public var metadata: [String: String]?
        }

        public struct Plugins: Encodable {
            public struct Value: Encodable {
                public var name: String
                public var path: String?
                public var version: String?
            }
            public var providers: [Value]?
            public var analyzers: [Value]?
            public var languages: [Value]?
        }

        public struct Resource: Encodable {
            public struct Options: Encodable {
                public var dependsOn: [Output<Any>]?
                public var protect: Bool?
                public var provider: Output<Any>?
            }
            public struct Lookup: Encodable {
                public var id: String
            }
            public var type: String
            public var properties: AnyEncodable?
            public var options: Options?
            public var get: Lookup?
        }

        public struct ConfigValue: Encodable {
            public var type: String
            public var `default`: String?
        }

        public typealias Resources = [String: Resource]

        public typealias Variables = [String: AnyEncodable]

        public typealias Config = [String: ConfigValue]

        public typealias Outputs = [String: AnyEncodable]

        public var name: String
        public var runtime: Runtime
        public var description: String?
        public var main: String?
        public var stackConfigDir: String?
        public var backend: Backend?
        public var options: Options?
        public var template: Template?
        public var plugins: Plugins?
        public var config: Config?
        public var resources: Resources?
        public var variables: Variables?
        public var outputs: Outputs?
    }
}
