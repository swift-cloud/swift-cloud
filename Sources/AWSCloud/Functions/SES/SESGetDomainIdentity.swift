extension AWS {
    public enum SES {
        public struct GetDomainIdentity {
            public let id: String
            public let arn: String
            public let domain: String
        }

        public static func getDomainIdentity(domain: String) -> Output<GetDomainIdentity> {
            let variable = Variable<GetDomainIdentity>.invoke(
                name: "\(domain)-identity",
                function: "aws:ses:getDomainIdentity",
                arguments: [
                    "domain": domain
                ]
            )
            return variable.output
        }
    }
}

extension Output<AWS.SES.GetDomainIdentity>: Linkable {
    public var name: Output<String> {
        self.domain
    }

    public var resources: [Output<String>] {
        [self.arn]
    }
}
