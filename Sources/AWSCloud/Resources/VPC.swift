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
                                "0.0.0.0/0",
                                "::/0",
                            ],
                        ]
                    ],
                ],
                options: resource.options
            )
        }

        fileprivate init(resource: Resource) {
            self.resource = resource
        }
    }
}

extension AWS.VPC {
    public static func `default`(options: Resource.Options? = nil) -> AWS.VPC {
        .init(
            resource: .init(
                name: "default-vpc",
                type: "awsx:ec2:DefaultVpc",
                options: options
            )
        )
    }
}
