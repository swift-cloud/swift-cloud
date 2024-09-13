extension AWS {
    public struct CDN: Component {
        public let distribution: Resource
        public let domainName: AWS.DomainName?

        public var name: Output<String> {
            distribution.name
        }

        public var hostname: Output<String> {
            distribution.output.keyPath("domainName")
        }

        public var url: Output<String> {
            if let domainName {
                return "https://\(domainName.domainName)"
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
            domainName: AWS.DomainName? = nil,
            options: Resource.Options? = nil
        ) {
            let cfProvider = AWS.Provider("cf", region: "us-east-1")

            self.domainName = domainName.map {
                AWS.DomainName(
                    $0.domainName,
                    zoneName: $0.zoneName,
                    options: .provider(cfProvider)
                )
            }

            let cachePolicy = Resource(
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
                options: .provider(cfProvider)
            )

            let originRequestPolicy = getOriginRequestPolicy(name: "Managed-AllViewerExceptHostHeader")

            guard let defaultOrigin = origins.defaultOrigin() else {
                fatalError("Missing a default origin. You must specify at least one origin with `path: *`.")
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
                        [$0.domainName]
                    },
                    "origins": origins.map { origin in
                        [
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
                    "defaultCacheBehavior": [
                        "targetOriginId": defaultOrigin.id,
                        "viewerProtocolPolicy": "redirect-to-https",
                        "allowedMethods": [
                            "GET",
                            "HEAD",
                            "OPTIONS",
                            "PUT",
                            "POST",
                            "PATCH",
                            "DELETE",
                        ],
                        "cachedMethods": [
                            "GET",
                            "HEAD",
                            "OPTIONS",
                        ],
                        "compress": true,
                        "defaultTtl": 0,
                        "cachePolicyId": cachePolicy.id,
                        "originRequestPolicyId": originRequestPolicy.id,
                    ],
                    "orderedCacheBehaviors": origins.withoutDefaultOrigin().map { origin in
                        [
                            "pathPattern": origin.path,
                            "targetOriginId": origin.id,
                            "viewerProtocolPolicy": "redirect-to-https",
                            "allowedMethods": [
                                "GET",
                                "HEAD",
                                "OPTIONS",
                                "PUT",
                                "POST",
                                "PATCH",
                                "DELETE",
                            ],
                            "cachedMethods": [
                                "GET",
                                "HEAD",
                                "OPTIONS",
                            ],
                            "compress": true,
                            "defaultTtl": 0,
                            "cachePolicyId": cachePolicy.id,
                            "originRequestPolicyId": originRequestPolicy.id,
                        ]
                    },
                    "viewerCertificate": [
                        "cloudfrontDefaultCertificate": domainName == nil ? true : nil,
                        "acmCertificateArn": domainName.map { $0.certificate.arn },
                        "sslSupportMethod": domainName.map { _ in "sni-only" },
                        "minimumProtocolVersion": "TLSv1.2_2021",
                    ],
                ],
                dependsOn: domainName.map { [$0.validation] },
                options: .provider(cfProvider)
            )

            domainName?.aliasTo(
                hostname: hostname,
                zoneId: zoneId
            )
        }
    }
}

extension AWS.CDN {
    public struct Origin {
        public let url: String
        public let path: String
        public let shieldRegion: String?

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

        public init(
            url: CustomStringConvertible,
            path: CustomStringConvertible,
            shieldRegion: CustomStringConvertible? = nil
        ) {
            self.url = url.description
            self.path = path.description
            self.shieldRegion = shieldRegion?.description
        }
    }
}

extension AWS.CDN.Origin {
    public static func function(_ function: AWS.Function, path: String, shieldRegion: String? = nil) -> Self {
        .init(url: function.url, path: path, shieldRegion: shieldRegion)
    }

    public static func webServer(_ server: AWS.WebServer, path: String, shieldRegion: String? = nil) -> Self {
        .init(url: server.url, path: path, shieldRegion: shieldRegion)
    }

    public static func url(_ url: String, path: String, shieldRegion: String? = nil) -> Self {
        .init(url: url, path: path, shieldRegion: shieldRegion)
    }
}

extension [AWS.CDN.Origin] {
    public static func function(_ function: AWS.Function, shieldRegion: String? = nil) -> Self {
        [.function(function, path: "*", shieldRegion: shieldRegion)]
    }

    public static func webServer(_ server: AWS.WebServer, shieldRegion: String? = nil) -> Self {
        [.webServer(server, path: "*", shieldRegion: shieldRegion)]
    }

    public static func url(_ url: String, shieldRegion: String? = nil) -> Self {
        [.url(url, path: "*", shieldRegion: shieldRegion)]
    }

    fileprivate func defaultOrigin() -> AWS.CDN.Origin? {
        self.first(where: { $0.isDefault })
    }

    fileprivate func withoutDefaultOrigin() -> [AWS.CDN.Origin] {
        self.filter { !$0.isDefault }
    }
}
