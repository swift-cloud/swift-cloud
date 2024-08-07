import Foundation

extension aws {
    public struct Queue: Component {
        public let queue: Resource
        public let deadLetterQueue: Resource

        public var name: String {
            queue.name
        }

        public var url: String {
            queue.keyPath("url")
        }

        public init(
            _ name: String,
            fifo: Bool = false,
            visibilityTimeout: TimeInterval = 30,
            messageRetentionInterval: TimeInterval = 345600,
            maxRetries: Int = 3,
            options: Resource.Options? = nil
        ) {
            deadLetterQueue = Resource(
                name: "\(name)-dlq",
                type: "aws:sqs:Queue",
                properties: [
                    "fifoQueue": .init(fifo),
                    "visibilityTimeoutSeconds": .init(visibilityTimeout),
                    "messageRetentionSeconds": 1_209_600,
                ],
                options: options
            )

            queue = Resource(
                name: name,
                type: "aws:sqs:Queue",
                properties: [
                    "fifoQueue": .init(fifo),
                    "visibilityTimeoutSeconds": .init(visibilityTimeout),
                    "messageRetentionSeconds": .init(messageRetentionInterval),
                    "redrivePolicy": Resource.JSON([
                        "deadLetterTargetArn": .init(deadLetterQueue.arn),
                        "maxReceiveCount": .init(maxRetries + 1),
                    ]),
                ],
                options: options
            )
        }
    }
}

extension aws.Queue {
    @discardableResult
    public func subscribe(
        _ function: aws.Function,
        batchSize: Int = 1,
        maximumConcurrency: Int? = nil
    ) -> aws.Queue {
        function.link(self)

        let _ = Resource(
            name: "\(queue.internalName)-subscription",
            type: "aws:lambda:EventSourceMapping",
            properties: [
                "eventSourceArn": .init(queue.arn),
                "functionName": .init(function.function.arn),
                "batchSize": .init(batchSize),
                "scalingConfig": maximumConcurrency.map {
                    ["maximumConcurrency": $0]
                },
            ],
            options: function.function.options
        )

        return self
    }
}

extension aws.Queue: Linkable {
    public var actions: [String] {
        [
            "sqs:SendMessage",
            "sqs:ReceiveMessage",
            "sqs:DeleteMessage",
            "sqs:GetQueueAttributes",
            "sqs:GetQueueUrl",
        ]
    }

    public var resources: [String] {
        [queue.arn]
    }
}
