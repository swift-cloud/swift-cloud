extension AWS {
    public struct DomainName: Component {
        public let domainName: String
        public let zoneName: String?
        public let certificate: AWS.TLSCertificate
        public let validation: AWS.TLSCertificate.Validation
        public let hostedZone: Variable
        public let validationRecord: Resource

        public var name: Output<String> {
            .init("", prefix: domainName)
        }

        public init(
            _ domainName: String,
            zoneName: String? = nil,
            options: Resource.Options? = nil
        ) {
            self.domainName = domainName
            self.zoneName = zoneName

            hostedZone = Variable.function(
                name: "\(domainName)-zone",
                function: "aws:route53:getZone",
                arguments: [
                    "name": zoneName ?? Self.inferredZoneName(domainName: domainName)
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
                    "zoneId": hostedZone.output.keyPath("id"),
                    "name": certificate.domainValidationOptions[0].recordName,
                    "type": certificate.domainValidationOptions[0].recordType,
                    "ttl": 60,
                    "allowOverwrite": true,
                    "records": [certificate.domainValidationOptions[0].recordValue],
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
    public func aliasTo(hostname: CustomStringConvertible, zoneId: CustomStringConvertible) {
        _ = Resource(
            name: "\(domainName)-alias",
            type: "aws:route53:Record",
            properties: [
                "name": domainName,
                "type": "A",
                "zoneId": hostedZone.output.keyPath("id"),
                "allowOverwrite": !Context.current.isProduction,
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
        let countThreshold =
            switch domainName {
            case _ where domainName.hasSuffix(".co.uk"): 3
            case _ where domainName.hasSuffix(".com.au"): 3
            case _ where domainName.hasSuffix(".co.jp"): 3
            case _ where domainName.hasSuffix(".co.nz"): 3
            case _ where domainName.hasSuffix(".co.za"): 3
            case _ where domainName.hasSuffix(".com.br"): 3
            case _ where domainName.hasSuffix(".com.mx"): 3
            default: 2
            }
        if parts.count > countThreshold {
            return parts.dropFirst().joined(separator: ".")
        } else {
            return parts.joined(separator: ".")
        }
    }
}
