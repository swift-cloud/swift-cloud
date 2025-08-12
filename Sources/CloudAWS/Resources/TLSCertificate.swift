extension AWS {
    public struct TLSCertificate: AWSResourceProvider {
        public let resource: Resource
        public let arn: Output<String>
        private let existingCertLookup: Variable<GetCertificate?>?

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
            reuseExisting: Bool = true,
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            if reuseExisting {
                // Look for existing certificate
                self.existingCertLookup = Variable<GetCertificate?>.invoke(
                    name: "\(hostname)-cert-lookup",
                    function: "aws:acm:getCertificate",
                    arguments: [
                        "domain": hostname,
                        "mostRecent": true,
                        "statuses": ["ISSUED"]
                    ]
                )
                
                // Create the certificate resource
                // Pulumi will handle conflicts by showing import suggestions
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
                
                self.arn = resource.output.keyPath("arn")
            } else {
                self.existingCertLookup = nil
                
                // Always create new certificate
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
                
                self.arn = resource.output.keyPath("arn")
            }
        }
        
        /// Check if an existing certificate was found for this domain
        public var hasExistingCertificate: Output<Bool> {
            if let existingCertLookup {
                return existingCertLookup.output.keyPath("arn")
            }
            return Output(prefix: "false", root: "", path: [])
        }
        
        /// Get the existing certificate ARN if available  
        /// This can be used to conditionally skip DNS validation if certificate already exists
        public var existingCertificateArn: Output<String?> {
            if let existingCertLookup {
                return existingCertLookup.output.keyPath("arn")
            }
            return Output(prefix: "null", root: "", path: [])
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
