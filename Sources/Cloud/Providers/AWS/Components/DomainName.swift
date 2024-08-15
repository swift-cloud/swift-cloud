extension AWS {
    public struct DomainName: Component {
        public let domainName: String
        public let certificate: AWS.TLSCertificate
        public let validation: AWS.TLSCertificate.Validation
        public let hostedZone: Variable
        public let validationRecord: Resource

        public var name: String {
            domainName
        }

        public init(
            domainName: String,
            zoneName: String? = nil,
            options: Resource.Options? = nil
        ) {
            self.domainName = domainName

            hostedZone = Variable(
                name: "\(domainName)-zone",
                definition: [
                    "fn::invoke": [
                        "function": "aws:route53:getZone",
                        "arguments": [
                            "name": zoneName ?? Self.inferredZoneName(domainName: domainName)
                        ],
                    ]
                ]
            )

            certificate = AWS.TLSCertificate(
                domainName: domainName,
                options: options
            )

            validationRecord = Resource(
                name: "\(domainName)-validation-record",
                type: "aws:route53:Record",
                properties: [
                    "zoneId": hostedZone.keyPath("id"),
                    "name": certificate.domainValidationOptions.recordName,
                    "type": certificate.domainValidationOptions.recordType,
                    "ttl": 60,
                    "records": [
                        certificate.domainValidationOptions.recordValue
                    ],
                ],
                options: options
            )

            validation = AWS.TLSCertificate.Validation(
                certificate: certificate,
                validationRecord: validationRecord
            )
        }
    }
}

extension AWS.DomainName {
    public func aliasTo(hostname: String, zoneId: String) {
        _ = Resource(
            name: "\(domainName)-alias",
            type: "aws:route53:Record",
            properties: [
                "name": domainName,
                "type": "A",
                "zoneId": hostedZone.keyPath("id"),
                "aliases": [
                    [
                        "name": hostname,
                        "evaluateTargetHealth": false,
                        "zoneId": zoneId,
                    ]
                ],
            ],
            options: certificate.resource.options
        )
    }
}

extension AWS.DomainName {
    fileprivate static func inferredZoneName(domainName: String) -> String {
        let parts = domainName.split(separator: ".")
        if parts.count > 2 {
            return parts.dropFirst().joined(separator: ".")
        } else {
            return domainName
        }
    }
}
