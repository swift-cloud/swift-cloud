extension aws {
    public struct VPC: ResourceProvider {
        public let resource: Resource

        fileprivate init(resource: Resource) {
            self.resource = resource
        }
    }
}

extension aws.VPC {
    public static let `default` = aws.VPC(
        resource: Resource(
            name: "default-vpc",
            type: "aws:ec2:DefaultVpc"
        )
    )
}
