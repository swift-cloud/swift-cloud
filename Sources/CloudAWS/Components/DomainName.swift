extension AWS {
    public struct SecureDomainName: AWSComponent {
        public let domainName: DomainName
        public let certificate: AWS.TLSCertificate
        public let validation: AWS.TLSCertificate.Validation
        public let validationRecord: any DNSProviderRecord

        public var name: Output<String> {
            "\(domainName.hostname)"
        }

        public var hostname: Output<String> {
            "\(domainName.hostname)"
        }

        public init(
            domainName: DomainName,
            options: Resource.Options? = nil
        ) {
            self.domainName = domainName

            certificate = AWS.TLSCertificate(
                hostname: domainName.hostname,
                options: options
            )

            validationRecord = domainName.dns.createRecord(
                type: certificate.domainValidationOptions[0].resourceRecordType,
                name: certificate.domainValidationOptions[0].resourceRecordName,
                target: certificate.domainValidationOptions[0].resourceRecordValue
            )

            validation = AWS.TLSCertificate.Validation(
                certificate: certificate,
                validationRecord: validationRecord
            )
        }
    }
}
