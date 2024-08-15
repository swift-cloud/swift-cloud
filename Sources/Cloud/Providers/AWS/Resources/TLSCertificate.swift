extension AWS {
    public struct TLSCertificate: ResourceProvider {
        public let resource: Resource

        public var domainValidationOptions: (recordName: String, recordType: String, recordValue: String) {
            let recordName = resource.keyPath("domainValidationOptions", "resourceRecordName")
            let recordType = resource.keyPath("domainValidationOptions", "resourceRecordType")
            let recordValue = resource.keyPath("domainValidationOptions", "resourceRecordValue")
            return (recordName, recordType, recordValue)
        }

        public var status: String {
            resource.keyPath("status")
        }

        public init(
            domainName: String,
            keyAlgorithm: KeyAlgorithm = .ecdsa,
            options: Resource.Options? = nil
        ) {
            resource = Resource(
                name: domainName,
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
