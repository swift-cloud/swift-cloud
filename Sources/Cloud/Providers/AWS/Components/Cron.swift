extension AWS {
    public struct Cron: Component {
        public let eventRule: Resource
        public let eventTarget: Resource

        public var name: String {
            eventRule.name
        }

        public var id: String {
            eventRule.id
        }

        public init(
            _ name: String,
            schedule: Expression,
            function: AWS.Function,
            enabled: Bool = true,
            options: Resource.Options? = nil
        ) {
            eventRule = Resource(
                name: "\(name)-cron-rule",
                type: "aws:cloudwatch:EventRule",
                properties: [
                    "scheduleExpression": schedule.value,
                    "state": enabled ? "ENABLED" : "DISABLED",
                ]
            )

            eventTarget = Resource(
                name: "\(name)-cron-target",
                type: "aws:cloudwatch:EventTarget",
                properties: [
                    "rule": eventRule.name,
                    "arn": function.function.arn,
                    "targetId": "\(tokenize(name))-\(function.function.internalName)-target-id",
                ]
            )
        }
    }
}

extension AWS.Cron {
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
}
