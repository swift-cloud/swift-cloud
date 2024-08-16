extension AWS {
    public struct CDN: Component {
        public let distribution: Resource
        public let domainName: AWS.DomainName?

        public var name: String {
            distribution.name
        }

        public var hostname: String {
            distribution.keyPath("domainName")
        }

        public var url: String {
            if let domainName {
                return "https://\(domainName.domainName)"
            } else {
                return "https://\(hostname)"
            }
        }

        public var zoneId: String {
            distribution.keyPath("hostedZoneId")
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
                    "origins": origins.enumerated().map { index, origin in
                        [
                            "domainName": origin.hostname,
                            "originId": "origin-\(index)",
                            "customOriginConfig": [
                                "httpPort": 80,
                                "httpsPort": 443,
                                "originProtocolPolicy": origin.isHTTPS ? "https-only" : "http-only",
                                "originSslProtocols": ["TLSv1.2"],
                            ],
                        ] as AnyEncodable
                    },
                    "defaultCacheBehavior": [
                        "targetOriginId": "origin-0",
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
                        "forwardedValues": [
                            "queryString": true,
                            "cookies": ["forward": "all"],
                        ],
                    ] as AnyEncodable,
                    "orderedCacheBehaviors": origins.enumerated().map { index, origin in
                        [
                            "pathPattern": origin.path,
                            "targetOriginId": "origin-\(index)",
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
                            "forwardedValues": [
                                "queryString": true,
                                "cookies": ["forward": "all"],
                            ],
                        ] as AnyEncodable
                    },
                    "viewerCertificate": [
                        "cloudfrontDefaultCertificate": domainName == nil ? true : nil,
                        "acmCertificateArn": domainName.map { $0.certificate.arn },
                        "sslSupportMethod": domainName.map { _ in "sni-only" },
                        "minimumProtocolVersion": "TLSv1.2_2021",
                    ] as AnyEncodable,
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

        public var hostname: String {
            .init(url.split(separator: "://").last!)
        }

        public var isHTTPS: Bool {
            url.hasPrefix("https")
        }

        public init(url: String, path: String) {
            self.url = url
            self.path = path
        }
    }
}

extension AWS.CDN.Origin {
    public static func function(_ function: AWS.Function, path: String = "*") -> Self {
        .init(url: function.url, path: path)
    }

    public static func webServer(_ server: AWS.WebServer, path: String = "*") -> Self {
        .init(url: server.url, path: path)
    }

    public static func url(_ url: String, path: String = "*") -> Self {
        .init(url: url, path: path)
    }
}

extension [AWS.CDN.Origin] {
    public static func function(_ function: AWS.Function) -> Self {
        [.function(function)]
    }

    public static func webServer(_ server: AWS.WebServer) -> Self {
        [.webServer(server)]
    }

    public static func url(_ url: String) -> Self {
        [.url(url)]
    }
}
