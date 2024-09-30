extension AWS {
    public struct GetARN {
        public let account: String
        public let arn: String
        public let region: String
        public let id: String
    }

    public static func getARN(_ resource: any AWSResourceProvider) -> Output<GetARN> {
        let variable = Variable<GetARN>.invoke(
            name: "\(resource.resource.chosenName)-arn",
            function: "aws:getArn",
            arguments: ["arn": resource.arn]
        )
        return variable.output
    }
}
