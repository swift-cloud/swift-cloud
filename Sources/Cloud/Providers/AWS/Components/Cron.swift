extension AWS {
    public struct Cron: Component {
        public let eventRule: Resource

        public var name: String {
            eventRule.name
        }

        public var id: String {
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
    public func invoke(_ function: AWS.Function) async throws -> AWS.Cron {
        _ = Resource(
            name: "\(name)-et",
            type: "aws:cloudwatch:EventTarget",
            properties: [
                "rule": eventRule.name,
                "arn": function.function.arn,
                "targetId": "\(tokenize(name))-\(function.function.internalName)-target-id",
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
