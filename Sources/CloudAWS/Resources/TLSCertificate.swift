extension AWS {
    public struct TLSCertificate: AWSResourceProvider {
        public let resource: Resource

        public var arn: Output<String> {
            resource.output.keyPath("arn")
        }

        public var domainValidationOptions:
            Output<[(resourceRecordName: String, resourceRecordType: String, resourceRecordValue: String)]>
        {
            return resource.output.keyPath("domainValidationOptions")
        }

        public var status: Output<String> {
            return resource.output.keyPath("status")
        }

        public init(
            hostname: any Input<String>,
            keyAlgorithm: KeyAlgorithm = .ecdsa,
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            resource = Resource(
                name: "\(hostname)-cert",
                type: "aws:acm:Certificate",
                properties: [
                    "domainName": hostname,
                    "keyAlgorithm": keyAlgorithm.rawValue,
                    "validationMethod": "DNS",
                ],
                options: options,
                context: context
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

        public init(certificate: AWS.TLSCertificate, validationRecord: any DNSProviderRecord) {
            resource = Resource(
                name: "\(certificate.resource.chosenName)-validation",
                type: "aws:acm:CertificateValidation",
                properties: [
                    "certificateArn": certificate.arn,
                    "validationRecordFqdns": [validationRecord.fqdn],
                ],
                options: certificate.resource.options,
                context: certificate.resource.context
            )
        }
    }
}
