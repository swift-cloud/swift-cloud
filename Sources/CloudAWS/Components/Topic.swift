import Foundation

extension AWS {
    public struct Topic: AWSComponent {
        public let topic: Resource

        public var name: Output<String> {
            topic.name
        }

        public init(
            _ name: String,
            fifo: Bool = false,
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            topic = Resource(
                name: name,
                type: "aws:sns:Topic",
                properties: [
                    "fifoTopic": fifo
                ],
                options: options,
                context: context
            )
        }
    }
}

extension AWS.Topic {
    @discardableResult
    public func subscribe(_ function: AWS.Function) -> AWS.Topic {
        function.link(self)

        let _ = Resource(
            name: "\(topic.chosenName)-\(function.function.chosenName)-subscription",
            type: "aws:sns:TopicSubscription",
            properties: [
                "topic": topic.arn,
                "protocol": "lambda",
                "endpoint": function.function.arn,
            ],
            options: function.function.options,
            context: function.function.context
        )

        return self
    }
}

extension AWS.Topic {
    @discardableResult
    public func subscribe(_ queue: AWS.Queue) -> AWS.Topic {
        let _ = Resource(
            name: "\(topic.chosenName)-\(queue.queue.chosenName)-subscription",
            type: "aws:sns:TopicSubscription",
            properties: [
                "topic": topic.arn,
                "protocol": "sqs",
                "endpoint": queue.queue.arn,
            ],
            options: queue.queue.options,
            context: queue.queue.context
        )

        return self
    }
}

extension AWS.Topic: Linkable {
    public var actions: [String] {
        [
            "sns:Publish"
        ]
    }

    public var resources: [Output<String>] {
        [topic.arn]
    }

    public var properties: LinkProperties? {
        return .init(
            type: "topic",
            name: topic.chosenName,
            properties: [
                "name": name
            ]
        )
    }
}
