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
            options: Resource.Options? = nil
        ) {
            eventRule = Resource(
                name: name,
                type: "aws:cloudwatch:EventRule",
                properties: [
                    "scheduleExpression": schedule.value,
                    "state": enabled ? "ENABLED" : "DISABLED",
                ]
            )
        }
    }
}

extension AWS.Cron {
    @discardableResult
    public func invoke(_ function: AWS.Function) -> AWS.Cron {
        _ = Resource(
            name: "\(name)-\(function.function.chosenName)-target",
            type: "aws:cloudwatch:EventTarget",
            properties: [
                "rule": eventRule.name,
                "arn": function.function.arn,
                "targetId": "\(tokenize(name))-\(function.function.chosenName)-target-id",
            ]
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
