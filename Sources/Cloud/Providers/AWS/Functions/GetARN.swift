extension AWS {
    public struct GetARNResult: VariableProvider {
        public typealias Shape = (
            account: String,
            arn: String,
            region: String,
            id: String
        )

        public let variable: Variable

        fileprivate init(_ resource: any ResourceProvider) {
            variable = Variable.function(
                name: "\(resource.resource.chosenName)-arn",
                function: "aws:getArn",
                arguments: ["arn": resource.arn]
            )
        }
    }
}

extension AWS {
    public static func getARN(_ resource: any ResourceProvider) -> Output<GetARNResult.Shape> {
        GetARNResult(resource).output
    }
}
