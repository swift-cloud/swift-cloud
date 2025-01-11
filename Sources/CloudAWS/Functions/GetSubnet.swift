extension AWS {
    public struct GetSubnet {
        public let arn: String
        public let availabilityZone: String
        public let availabilityZoneId: String
        public let id: String
        public let vpcId: String
    }

    public static func getSubnet(_ id: any Input<String>) -> Output<GetSubnet> {
        let variable = Variable<GetSubnet>.invoke(
            name: "get-subnet-\(id)",
            function: "aws:ec2:getSubnet",
            arguments: ["id": id]
        )
        return variable.output
    }
}
