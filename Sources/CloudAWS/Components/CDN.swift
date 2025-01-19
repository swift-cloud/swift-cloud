import CloudCore

extension AWS {
    public struct CDN: AWSComponent {
        public let distribution: Resource
        public let secureDomainName: AWS.SecureDomainName?

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
                options: .provider(cfProvider),
                context: context
            )

            let originRequestPolicy = Cloudfront.getOriginRequestPolicy(name: "Managed-AllViewerExceptHostHeader")

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
                        [$0.hostname]
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
                        "acmCertificateArn": secureDomainName.map { $0.certificate.arn },
                        "sslSupportMethod": secureDomainName.map { _ in "sni-only" },
                        "minimumProtocolVersion": "TLSv1.2_2021",
                    ],
                ],
                options: .provider(cfProvider),
                context: context,
                dependsOn: secureDomainName.map { [$0.validation] }
            )

            domainName?.aliasTo(self.hostname)
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
            url: any Input<String>,
            path: any Input<String>,
            shieldRegion: (any Input<String>)? = nil
        ) {
            self.url = url.description
            self.path = path.description
            self.shieldRegion = shieldRegion?.description
        }
    }
}

extension AWS.CDN.Origin {
    public static func function(
        _ function: AWS.Function, path: any Input<String>, shieldRegion: (any Input<String>)? = nil
    ) -> Self {
        .init(url: function.url, path: path, shieldRegion: shieldRegion)
    }

    public static func webServer(
        _ server: AWS.WebServer, path: any Input<String>, shieldRegion: (any Input<String>)? = nil
    ) -> Self {
        .init(url: server.url, path: path, shieldRegion: shieldRegion)
    }

    public static func url(
        _ url: any Input<String>, path: any Input<String>, shieldRegion: (any Input<String>)? = nil
    ) -> Self {
        .init(url: url, path: path, shieldRegion: shieldRegion)
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

    fileprivate func defaultOrigin() -> AWS.CDN.Origin? {
        self.first(where: { $0.isDefault })
    }

    fileprivate func withoutDefaultOrigin() -> [AWS.CDN.Origin] {
        self.filter { !$0.isDefault }
    }
}
