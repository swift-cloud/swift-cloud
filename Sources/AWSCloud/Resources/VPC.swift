extension AWS {
    public struct VPC: ResourceProvider {
        public let resource: Resource

        public var publicSubnetIds: Output<[String]> {
            resource.output.keyPath("publicSubnetIds")
        }

        public var privateSubnetIds: Output<[String]> {
            resource.output.keyPath("privateSubnetIds")
        }

        fileprivate init(resource: Resource) {
            self.resource = resource
        }
    }
}

extension AWS.VPC {
    public static let `default` = AWS.VPC(
        resource: Resource(
            name: "default-vpc",
            type: "awsx:ec2:DefaultVpc"
        )
    )
}
