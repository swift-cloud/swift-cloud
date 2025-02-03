extension AWS {
    public struct Cron: AWSComponent {
        public let eventRule: Resource

        public var name: Output<String> {
            eventRule.name
        }

        public var id: Output<String> {
            eventRule.id
        }

        public init(
            _ name: String,
            schedule: Expression,
            enabled: Bool = true,
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            eventRule = Resource(
                name: name,
                type: "aws:cloudwatch:EventRule",
                properties: [
                    "scheduleExpression": schedule.value,
                    "state": enabled ? "ENABLED" : "DISABLED",
                ],
                options: options,
                context: context
            )
        }
    }
}

extension AWS.Cron {
    @discardableResult
    public func invoke(_ function: AWS.Function) -> AWS.Cron {
        _ = Resource(
            name: tokenize(eventRule.chosenName, function.function.chosenName, "permission"),
            type: "aws:lambda:Permission",
            properties: [
                "action": "lambda:InvokeFunction",
                "function": function.function.name,
                "principal": "events.amazonaws.com",
                "sourceArn": eventRule.arn,
            ],
            options: function.function.options,
            context: function.function.context
        )
        _ = Resource(
            name: tokenize(eventRule.chosenName, function.function.chosenName, "target"),
            type: "aws:cloudwatch:EventTarget",
            properties: [
                "rule": eventRule.name,
                "arn": function.function.arn,
            ],
            options: function.function.options,
            context: function.function.context
        )
        return self
    }
}

extension AWS.Cron {
    public enum Expression: Sendable {
        case cron(_ value: String)
        case rate(_ value: Duration)

        var value: String {
            switch self {
            case .cron(let value):
                return "cron(\(value))"
            case .rate(let value):
                let minutes = Int(value.components.seconds / 60)
                let unit = minutes == 1 ? "minute" : "minutes"
                return "rate(\(minutes) \(unit))"
            }
        }
    }
}
