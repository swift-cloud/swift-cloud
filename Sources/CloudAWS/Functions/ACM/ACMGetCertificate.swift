extension AWS {
    public struct GetCertificate {
        public let arn: String?
        public let status: String?
        public let domainName: String
    }

    public static func getCertificate(domainName: any Input<String>) -> Output<GetCertificate?> {
        let variable = Variable<GetCertificate?>.invoke(
            name: "\(domainName)-existing-cert",
            function: "aws:acm:getCertificate",
            arguments: [
                "domain": domainName,
                "mostRecent": true,
                "statuses": ["ISSUED"]
            ]
        )
        return variable.output
    }
}