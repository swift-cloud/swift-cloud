import Foundation

extension AWS {
    public struct Bucket: AWSComponent {
        internal let bucket: Resource
        internal let ownershipControls: Resource
        internal let publicAccessBlock: Resource
        internal let corsConfiguration: Resource?

        public var name: Output<String> {
            bucket.id
        }

        public var region: Output<String> {
            getARN(bucket).region
        }

        public var hostname: Output<String> {
            bucket.output.keyPath("bucketRegionalDomainName")
        }

        public init(
            _ name: String,
            cors: [CORSRule]? = nil,
            forceDestroy: Bool = true,
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            bucket = Resource(
                name: name,
                type: "aws:s3:Bucket",
                properties: [
                    "forceDestroy": forceDestroy
                ],
                options: options,
                context: context
            )

            ownershipControls = Resource(
                name: "\(name)-oc",
                type: "aws:s3:BucketOwnershipControls",
                properties: [
                    "bucket": bucket.output,
                    "rule": [
                        "objectOwnership": "ObjectWriter"
                    ],
                ],
                options: options,
                context: context
            )

            publicAccessBlock = Resource(
                name: "\(name)-pab",
                type: "aws:s3:BucketPublicAccessBlock",
                properties: [
                    "bucket": bucket.output,
                    "blockPublicAcls": false,
                ],
                options: options,
                context: context
            )

            if let cors {
                corsConfiguration = Resource(
                    name: "\(name)-cors",
                    type: "aws:s3:BucketCorsConfigurationV2",
                    properties: [
                        "bucket": bucket.output,
                        "corsRules": cors.map { rule in
                            var ruleDict: [String: AnyEncodable] = [
                                "allowedMethods": AnyEncodable(rule.allowedMethods.map { $0.rawValue }),
                                "allowedOrigins": AnyEncodable(rule.allowedOrigins),
                            ]
                            if !rule.allowedHeaders.isEmpty {
                                ruleDict["allowedHeaders"] = AnyEncodable(rule.allowedHeaders)
                            }
                            if !rule.exposeHeaders.isEmpty {
                                ruleDict["exposeHeaders"] = AnyEncodable(rule.exposeHeaders)
                            }
                            if let maxAge = rule.maxAgeSeconds {
                                ruleDict["maxAgeSeconds"] = AnyEncodable(maxAge)
                            }
                            return AnyEncodable(ruleDict)
                        },
                    ],
                    options: options,
                    context: context
                )
            } else {
                corsConfiguration = nil
            }
        }
    }
}

extension AWS.Bucket {
    public struct CORSRule {
        public enum HTTPMethod: String {
            case get = "GET"
            case put = "PUT"
            case post = "POST"
            case delete = "DELETE"
            case head = "HEAD"
        }
        public var allowedMethods: [HTTPMethod]
        public var allowedOrigins: [String]
        public var allowedHeaders: [String]
        public var exposeHeaders: [String]
        public var maxAgeSeconds: Int?

        public init(
            allowedMethods: [HTTPMethod] = [.get, .head],
            allowedOrigins: [String] = ["*"],
            allowedHeaders: [String] = [],
            exposeHeaders: [String] = [],
            maxAgeSeconds: Int? = nil
        ) {
            for origin in allowedOrigins {
                Self.validateOrigin(origin)
            }
            self.allowedMethods = allowedMethods
            self.allowedOrigins = allowedOrigins
            self.allowedHeaders = allowedHeaders
            self.exposeHeaders = exposeHeaders
            self.maxAgeSeconds = maxAgeSeconds
        }

        private static func validateOrigin(_ origin: String) {
            guard isValidOrigin(origin) else {
                fatalError(
                    "Invalid CORS origin '\(origin)': must be '*' or a valid origin URL (scheme://host) without path, query, or fragment."
                )
            }
        }

        internal static func isValidOrigin(_ origin: String) -> Bool {
            guard origin != "*" else { return true }

            guard let url = URL(string: origin),
                let scheme = url.scheme,
                scheme == "http" || scheme == "https",
                let host = url.host,
                !host.isEmpty,
                url.path == "/" || url.path.isEmpty,
                url.query == nil,
                url.fragment == nil
            else {
                return false
            }

            return true
        }
    }
}

extension AWS.Bucket: Linkable {
    public var actions: [String] {
        [
            "s3:PutObject",
            "s3:GetObject",
            "s3:DeleteObject",
            "s3:ListBucket",
        ]
    }

    public var resources: [Output<String>] {
        [
            "\(bucket.arn)",
            "\(bucket.arn)/*",
        ]
    }

    public var properties: LinkProperties? {
        return .init(
            type: "bucket",
            name: bucket.chosenName,
            properties: [
                "name": name,
                "hostname": hostname,
                "url": "https://\(hostname)",
            ]
        )
    }
}
