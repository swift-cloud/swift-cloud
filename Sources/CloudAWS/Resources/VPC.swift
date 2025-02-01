extension AWS {
    public struct VPC: AWSResourceProvider {
        public let resource: Resource

        public var id: Output<String> {
            resource.output.keyPath("vpcId")
        }

        public var urn: Output<String> {
            resource.output.keyPath("urn")
        }

        public var publicSubnetIds: Output<[String]> {
            resource.output.keyPath("publicSubnetIds")
        }

        public var privateSubnetIds: Output<[String]> {
            resource.output.keyPath("privateSubnetIds")
        }

        public var defaultSecurityGroup: Resource {
            .init(
                name: "\(resource.chosenName)-default-sg",
                type: "aws:ec2:DefaultSecurityGroup",
                properties: [
                    "vpcId": self.id,
                    "ingress": [
                        [
                            "protocol": "-1",
                            "self": true,
                            "fromPort": 0,
                            "toPort": 0,
                        ]
                    ],
                    "egress": [
                        [
                            "protocol": "-1",
                            "fromPort": 0,
                            "toPort": 0,
                            "cidrBlocks": [
                                "0.0.0.0/0"
                            ],
                        ]
                    ],
                ],
                options: resource.options,
                context: resource.context
            )
        }

        public init(
            _ name: String,
            cidrBlock: String = "10.0.0.0/16",
            natGatewatStrategy: NatGatewayStrategy = .disabled,
            enableDnsHostnames: Bool = true,
            enableDnsSupport: Bool = true,
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            resource = .init(
                name: name,
                type: "awsx:ec2:Vpc",
                properties: [
                    "cidrBlock": cidrBlock,
                    "enableDnsHostnames": enableDnsHostnames,
                    "enableDnsSupport": enableDnsSupport,
                    "subnetStrategy": "Auto",
                    "natGateways": [
                        "strategy": natGatewatStrategy
                    ],
                ],
                options: options,
                context: context
            )
        }

        fileprivate init(resource: Resource) {
            self.resource = resource
        }
    }
}

extension AWS.VPC {
    public enum NatGatewayStrategy: String, Sendable, Codable {
        case disabled = "None"
        case standard = "Single"
        case highAvailability = "OnePerAz"
    }
}

extension AWS.VPC {
    public static func `default`(
        options: Resource.Options? = nil,
        context: Context = .current
    ) -> AWS.VPC {
        .init(
            resource: .init(
                name: "default-vpc",
                type: "awsx:ec2:DefaultVpc",
                properties: nil,
                options: options,
                context: context
            )
        )
    }
}

extension AWS.VPC {
    public enum Configuration {
        case `public`(_ vpc: AWS.VPC)
        case `private`(_ vpc: AWS.VPC)

        public var vpc: AWS.VPC {
            switch self {
            case .public(let vpc):
                return vpc
            case .private(let vpc):
                return vpc
            }
        }

        public var securityGroupId: Output<String> {
            return vpc.defaultSecurityGroup.id
        }

        public var subnetIds: Output<[String]> {
            switch self {
            case .public(let vpc):
                return vpc.publicSubnetIds
            case .private(let vpc):
                return vpc.privateSubnetIds
            }
        }
    }
}
