extension aws {
    public struct SecurityGroup: ResourceProvider {
        public let resource: Resource
        private let ingressRules: [Resource]
        private let egressRules: [Resource]

        public init(
            _ name: String,
            ingress: [Rule],
            egress: [Rule],
            options: Resource.Options? = nil
        ) {
            let resource = Resource(
                name: name,
                type: "aws:ec2:SecurityGroup",
                options: options
            )

            let ingressRules = ingress.enumerated().map { index, rule in
                Resource(
                    name: "\(name)-ingress-rule-\(index)",
                    type: "aws:vpc:SecurityGroupIngressRule",
                    properties: [
                        "securityGroupId": resource.id,
                        "ipProtocol": "-1",
                        rule.propertyKey: rule.propertyValue,
                    ],
                    options: options
                )
            }

            let egressRules = egress.enumerated().map { index, rule in
                Resource(
                    name: "\(name)-egress-rule-\(index)",
                    type: "aws:vpc:SecurityGroupEgressRule",
                    properties: [
                        "securityGroupId": resource.id,
                        "ipProtocol": "-1",
                        rule.propertyKey: rule.propertyValue,
                    ],
                    options: options
                )
            }

            self.resource = resource
            self.ingressRules = ingressRules
            self.egressRules = egressRules
        }
    }
}

extension aws.SecurityGroup {
    public enum Rule {
        case ipv4(String)
        case ipv6(String)
        case securityGroup(aws.SecurityGroup)

        fileprivate var propertyKey: String {
            switch self {
            case .ipv4:
                return "cidrIpv4"
            case .ipv6:
                return "cidrIpv6"
            case .securityGroup:
                return "referencedSecurityGroupId"
            }
        }

        fileprivate var propertyValue: String {
            switch self {
            case .ipv4(let cidr):
                return cidr
            case .ipv6(let cidr):
                return cidr
            case .securityGroup(let securityGroup):
                return securityGroup.resource.id
            }
        }
    }
}

extension [aws.SecurityGroup.Rule] {
    public static var all: [aws.SecurityGroup.Rule] {
        [.ipv4("0.0.0.0/0"), .ipv6("::/0")]
    }
}
