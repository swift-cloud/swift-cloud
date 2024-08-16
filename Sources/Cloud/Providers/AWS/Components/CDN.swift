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
            origins: [(path: String, url: String)],
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
                            "domainName": origin.url.split(separator: "://").last!,
                            "originId": "origin-\(index)",
                            "customOriginConfig": [
                                "httpPort": 80,
                                "httpsPort": 443,
                                "originProtocolPolicy": origin.url.hasPrefix("https") ? "https-only" : "http-only",
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
                options: .provider(cfProvider)
            )
        }
    }
}
