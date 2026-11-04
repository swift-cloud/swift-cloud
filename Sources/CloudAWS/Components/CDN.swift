import CloudCore

extension AWS {
    public struct CDN: AWSComponent {
        public let distribution: Resource
        public let secureDomainName: AWS.SecureDomainName?
        /// Signs CloudFront's requests to bucket origins, so the buckets can stay private. Nil without any.
        public let originAccessControl: Resource?

        public var name: Output<String> {
            distribution.name
        }

        public var hostname: Output<String> {
            distribution.output.keyPath("domainName")
        }

        public var url: Output<String> {
            if let secureDomainName {
                return "https://\(secureDomainName.hostname)"
            } else {
                return "https://\(hostname)"
            }
        }

        public var zoneId: Output<String> {
            distribution.output.keyPath("hostedZoneId")
        }

        public init(
            _ name: String,
            origins: [Origin],
            domainName: DomainName? = nil,
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            let cfProvider = AWS.Provider("cf", region: "us-east-1")

            secureDomainName = domainName.map {
                AWS.SecureDomainName(
                    domainName: $0,
                    options: .provider(cfProvider)
                )
            }

            let bucketOrigins = origins.filter { $0.bucket != nil }
            // Only the paths in front of an app use it, not the ones in front of buckets.
            let needsAppPolicies = bucketOrigins.count < origins.count

            let cachePolicy = !needsAppPolicies ? nil : Resource(
                name: "\(name)-cache-policy",
                type: "aws:cloudfront:CachePolicy",
                properties: [
                    "defaultTtl": 0,
                    "minTtl": 0,
                    "maxTtl": 31_536_000,
                    "parametersInCacheKeyAndForwardedToOrigin": [
                        "cookiesConfig": [
                            "cookieBehavior": "none"
                        ],
                        "headersConfig": [
                            "headerBehavior": "none"
                        ],
                        "queryStringsConfig": [
                            "queryStringBehavior": "all"
                        ],
                        "enableAcceptEncodingGzip": true,
                        "enableAcceptEncodingBrotli": true,
                    ],
                ],
                options: .provider(cfProvider),
                context: context
            )

            let originRequestPolicy = !needsAppPolicies ? nil : Cloudfront.getOriginRequestPolicy(name: "Managed-AllViewerExceptHostHeader")

            let originAccessControl = bucketOrigins.isEmpty ? nil : Resource(
                name: "\(name)-oac",
                type: "aws:cloudfront:OriginAccessControl",
                properties: [
                    // Names are unique per account and allow up to 64 characters.
                    "name": tokenize(context.stage, name, maxLength: 64),
                    "originAccessControlOriginType": "s3",
                    "signingBehavior": "always",
                    "signingProtocol": "sigv4",
                ],
                options: .provider(cfProvider),
                context: context
            )
            self.originAccessControl = originAccessControl

            // Files in a bucket don't change behind a key: cache them up to a year, keyed on the path alone.
            let bucketCachePolicy = bucketOrigins.isEmpty ? nil : Cloudfront.getCachePolicy(name: "Managed-CachingOptimized")

            guard let defaultOrigin = origins.defaultOrigin() else {
                fatalError("Missing a default origin. You must specify at least one origin with `path: *`.")
            }

            func cacheBehavior(_ origin: Origin) -> AnyEncodable {
                var behavior: [String: Any?] = [
                    "targetOriginId": origin.id,
                    "viewerProtocolPolicy": "redirect-to-https",
                    "cachedMethods": ["GET", "HEAD", "OPTIONS"],
                    "compress": true,
                    "functionAssociations": origin.functionAssociations,
                ]
                // The default behavior has no path, and rejects the key altogether.
                if !origin.isDefault {
                    behavior["pathPattern"] = origin.path
                }
                if origin.bucket != nil {
                    behavior["allowedMethods"] = ["GET", "HEAD", "OPTIONS"]
                    behavior["cachePolicyId"] = bucketCachePolicy?.id
                } else {
                    behavior["allowedMethods"] = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
                    behavior["defaultTtl"] = 0
                    behavior["cachePolicyId"] = cachePolicy?.id
                    behavior["originRequestPolicyId"] = originRequestPolicy?.id
                }
                return AnyEncodable(behavior)
            }

            distribution = Resource(
                name: name,
                type: "aws:cloudfront:Distribution",
                properties: [
                    "defaultRootObject": "",
                    "enabled": true,
                    "isIpv6Enabled": true,
                    "retainOnDelete": false,
                    "waitForDeployment": false,
                    "httpVersion": "http2and3",
                    "restrictions": [
                        "geoRestriction": [
                            "restrictionType": "none"
                        ]
                    ],
                    "aliases": domainName.map {
                        [$0.hostname]
                    },
                    "origins": origins.map { origin -> AnyEncodable in
                        if origin.bucket != nil {
                            return [
                                "domainName": origin.hostname,
                                "originId": origin.id,
                                "originAccessControlId": originAccessControl?.id,
                                "originShield": origin.shieldRegion.map {
                                    ["enabled": true, "originShieldRegion": $0] as Any
                                },
                            ]
                        }
                        return [
                            "domainName": origin.hostname,
                            "originId": origin.id,
                            "customOriginConfig": [
                                "httpPort": 80,
                                "httpsPort": 443,
                                "originProtocolPolicy": origin.isHTTPS ? "https-only" : "http-only",
                                "originSslProtocols": ["TLSv1.2"],
                            ],
                            "originShield": origin.shieldRegion.map {
                                ["enabled": true, "originShieldRegion": $0] as Any
                            },
                        ]
                    },
                    "defaultCacheBehavior": cacheBehavior(defaultOrigin),
                    "orderedCacheBehaviors": origins.withoutDefaultOrigin().map(cacheBehavior),
                    "viewerCertificate": [
                        "cloudfrontDefaultCertificate": domainName == nil ? true : nil,
                        "acmCertificateArn": secureDomainName.map { $0.certificate.arn },
                        "sslSupportMethod": secureDomainName.map { _ in "sni-only" },
                        "minimumProtocolVersion": "TLSv1.2_2021",
                    ],
                ],
                options: .provider(cfProvider),
                context: context,
                dependsOn: secureDomainName.map { [$0.validation] }
            )

            // A bucket has a single policy: this one lets only this distribution read it.
            var bucketsWithPolicy: Set<String> = []
            for bucket in bucketOrigins.compactMap(\.bucket) {
                guard bucketsWithPolicy.insert(bucket.bucket.chosenName).inserted else {
                    continue
                }
                _ = Resource(
                    name: "\(name)-\(bucket.bucket.chosenName)-policy",
                    type: "aws:s3:BucketPolicy",
                    properties: [
                        "bucket": bucket.name,
                        "policy": Resource.JSON([
                            "Version": "2012-10-17",
                            "Statement": [
                                [
                                    "Effect": "Allow",
                                    "Principal": ["Service": "cloudfront.amazonaws.com"],
                                    "Action": "s3:GetObject",
                                    "Resource": "\(bucket.bucket.arn)/*",
                                    "Condition": [
                                        "StringEquals": ["AWS:SourceArn": distribution.arn]
                                    ],
                                ]
                            ],
                        ]),
                    ],
                    options: options,
                    context: context,
                    dependsOn: [bucket.publicAccessBlock]
                )
            }

            domainName?.aliasTo(self.hostname)
        }
    }
}

extension AWS.CDN {
    public struct Origin {
        public let url: String
        public let path: String
        public let shieldRegion: String?
        /// CloudFront Functions that run on this path's cache behavior.
        public let functions: [AWS.CDN.Function.Association]
        /// Set for a private S3 bucket, read through Origin Access Control.
        let bucket: AWS.Bucket?

        public var id: String {
            tokenize("origin", isDefault ? "default" : isRoot ? "root" : path)
        }

        public var hostname: String {
            .init(url.split(separator: "://").last!)
        }

        public var isHTTPS: Bool {
            url.hasPrefix("https")
        }

        public var isDefault: Bool {
            path == "*" || path == "/*"
        }

        public var isRoot: Bool {
            path == "/"
        }

        var functionAssociations: [[String: String]]? {
            functions.isEmpty ? nil : functions.map { ["eventType": $0.eventType.rawValue, "functionArn": $0.functionArn] }
        }

        public init(
            url: any Input<String>,
            path: any Input<String>,
            shieldRegion: (any Input<String>)? = nil,
            functions: [AWS.CDN.Function.Association] = []
        ) {
            self.init(url: url, path: path, shieldRegion: shieldRegion, functions: functions, bucket: nil)
        }

        init(
            url: any Input<String>,
            path: any Input<String>,
            shieldRegion: (any Input<String>)?,
            functions: [AWS.CDN.Function.Association],
            bucket: AWS.Bucket?
        ) {
            self.url = url.description
            self.path = path.description
            self.shieldRegion = shieldRegion?.description
            self.functions = functions
            self.bucket = bucket
        }
    }
}

extension AWS.CDN.Origin {
    public static func function(
        _ function: AWS.Function,
        path: any Input<String>,
        shieldRegion: (any Input<String>)? = nil,
        functions: [AWS.CDN.Function.Association] = []
    ) -> Self {
        .init(url: function.url, path: path, shieldRegion: shieldRegion, functions: functions)
    }

    public static func webServer(
        _ server: AWS.WebServer,
        path: any Input<String>,
        shieldRegion: (any Input<String>)? = nil,
        functions: [AWS.CDN.Function.Association] = []
    ) -> Self {
        .init(url: server.url, path: path, shieldRegion: shieldRegion, functions: functions)
    }

    public static func url(
        _ url: any Input<String>,
        path: any Input<String>,
        shieldRegion: (any Input<String>)? = nil,
        functions: [AWS.CDN.Function.Association] = []
    ) -> Self {
        .init(url: url, path: path, shieldRegion: shieldRegion, functions: functions)
    }

    /// A private S3 bucket. CloudFront reads it through Origin Access Control, and the CDN sets the
    /// bucket's policy to allow only that, so the bucket can block all public access.
    public static func bucket(
        _ bucket: AWS.Bucket,
        path: any Input<String>,
        shieldRegion: (any Input<String>)? = nil,
        functions: [AWS.CDN.Function.Association] = []
    ) -> Self {
        .init(url: "https://\(bucket.hostname)", path: path, shieldRegion: shieldRegion, functions: functions, bucket: bucket)
    }
}

extension [AWS.CDN.Origin] {
    public static func function(_ function: AWS.Function, shieldRegion: (any Input<String>)? = nil) -> Self {
        [.function(function, path: "*", shieldRegion: shieldRegion)]
    }

    public static func webServer(_ server: AWS.WebServer, shieldRegion: (any Input<String>)? = nil) -> Self {
        [.webServer(server, path: "*", shieldRegion: shieldRegion)]
    }

    public static func url(_ url: any Input<String>, shieldRegion: (any Input<String>)? = nil) -> Self {
        [.url(url, path: "*", shieldRegion: shieldRegion)]
    }

    public static func bucket(_ bucket: AWS.Bucket, shieldRegion: (any Input<String>)? = nil) -> Self {
        [.bucket(bucket, path: "*", shieldRegion: shieldRegion)]
    }

    fileprivate func defaultOrigin() -> AWS.CDN.Origin? {
        self.first(where: { $0.isDefault })
    }

    fileprivate func withoutDefaultOrigin() -> [AWS.CDN.Origin] {
        self.filter { !$0.isDefault }
    }
}

extension AWS.CDN: Linkable {
    /// Linking a CDN lets a function invalidate its cached paths, e.g. after deleting a file.
    public var actions: [String] {
        [
            "cloudfront:CreateInvalidation",
            "cloudfront:GetInvalidation",
        ]
    }

    public var resources: [Output<String>] {
        [distribution.arn]
    }

    public var properties: LinkProperties? {
        .init(
            type: "cdn",
            name: distribution.chosenName,
            properties: [
                "id": distribution.id,
                "hostname": hostname,
                "url": url,
            ]
        )
    }
}
