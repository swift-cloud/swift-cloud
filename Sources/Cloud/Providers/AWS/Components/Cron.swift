extension aws {
    public struct Cron: Component {
        public enum Expression: Sendable {
            case cron(_ value: String)
            case rate(_ value: String)

            var value: String {
                switch self {
                case .cron(let value):
                    return "cron(\(value))"
                case .rate(let value):
                    return "rate(\(value))"
                }
            }
        }

        internal let eventRule: Resource
        internal let eventTarget: Resource

        public var id: String {
            eventTarget.id
        }

        public init(
            _ name: String,
            expression: Expression,
            function: aws.Function,
            enabled: Bool = true,
            options: Resource.Options? = nil
        ) {
            eventRule = Resource(
                name: "\(name)-cron-rule",
                type: "aws:cloudwatch:EventRule",
                properties: [
                    "scheduleExpression": .init(expression.value),
                    "state": enabled ? "ENABLED" : "DISABLED",
                ]
            )

            eventTarget = Resource(
                name: "\(name)-cron-target",
                type: "aws:cloudwatch:EventTarget",
                properties: [
                    "rule": .init(eventRule.name),
                    "arn": .init(function.function.arn),
                    "targetId": "\(tokenize(name))-\(function.function.internalName)-target-id",
                ]
            )
        }
    }
}
