extension AWS {
    public struct TLSCertificate: ResourceProvider {
        public let resource: Resource

        public var domainValidationOptions: Output<[(recordName: String, recordType: String, recordValue: String)]> {
            return resource.output.keyPath("domainValidationOptions")
        }

        public var status: Output<String> {
            resource.output.keyPath("status")
        }

        public init(
            domainName: String,
            keyAlgorithm: KeyAlgorithm = .ecdsa,
            options: Resource.Options? = nil
        ) {
            resource = Resource(
                name: "\(domainName)-cert",
                type: "aws:acm:Certificate",
                properties: [
                    "domainName": domainName,
                    "keyAlgorithm": keyAlgorithm.rawValue,
                    "validationMethod": "DNS",
                ],
                options: options
            )
        }
    }
}

extension AWS.TLSCertificate {
    public enum KeyAlgorithm: String, Sendable, Encodable {
        case rsa = "RSA_2048"
        case ecdsa = "EC_prime256v1"
    }
}

extension AWS.TLSCertificate {
    public struct Validation: ResourceProvider {
        public let resource: Resource

        public init(certificate: AWS.TLSCertificate, validationRecord: Resource) {
            resource = Resource(
                name: "\(certificate.resource.chosenName)-validation",
                type: "aws:acm:CertificateValidation",
                properties: [
                    "certificateArn": certificate.arn,
                    "validationRecordFqdns": [
                        validationRecord.output.keyPath("fqdn")
                    ],
                ],
                options: certificate.resource.options
            )
        }
    }
}
