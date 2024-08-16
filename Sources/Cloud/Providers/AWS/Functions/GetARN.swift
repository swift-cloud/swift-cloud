extension AWS {
    public struct GetARNResult: VariableProvider {
        public let variable: Variable

        public var account: String {
            variable.keyPath("account")
        }

        public var arn: String {
            variable.keyPath("arn")
        }

        public var region: String {
            variable.keyPath("region")
        }

        public var id: String {
            variable.keyPath("id")
        }

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
    public static func getARN(_ resource: any ResourceProvider) -> GetARNResult {
        .init(resource)
    }
}
