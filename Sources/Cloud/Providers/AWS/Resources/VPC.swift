extension aws {
    public struct VPC: ResourceProvider {
        public let resource: Resource

        public var publicSubnetIds: String {
            resource.keyPath("publicSubnetIds")
        }

        public var privateSubnetIds: String {
            resource.keyPath("privateSubnetIds")
        }

        fileprivate init(resource: Resource) {
            self.resource = resource
        }
    }
}

extension aws.VPC {
    public static let `default` = aws.VPC(
        resource: Resource(
            name: "default-vpc",
            type: "awsx:ec2:DefaultVpc"
        )
    )
}
