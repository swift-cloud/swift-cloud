import Foundation

extension AWS {
    public struct Queue: AWSComponent {
        public let queue: Resource
        public let deadLetterQueue: Resource

        public var name: Output<String> {
            queue.name
        }

        public var region: Output<String> {
            getARN(queue).region
        }

        public var url: Output<String> {
            queue.output.keyPath("url")
        }

        public init(
            _ name: String,
            fifo: Bool = false,
            visibilityTimeout: Duration = .seconds(30),
            messageRetentionInterval: Duration = .seconds(345600),
            maxRetries: Int = 3,
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            deadLetterQueue = Resource(
                name: "\(name)-dlq",
                type: "aws:sqs:Queue",
                properties: [
                    "fifoQueue": fifo,
                    "receiveWaitTimeSeconds": 20,
                    "visibilityTimeoutSeconds": visibilityTimeout.components.seconds,
                    "messageRetentionSeconds": 1_209_600,
                ],
                options: options,
                context: context
            )

            queue = Resource(
                name: name,
                type: "aws:sqs:Queue",
                properties: [
                    "fifoQueue": fifo,
                    "visibilityTimeoutSeconds": visibilityTimeout.components.seconds,
                    "messageRetentionSeconds": messageRetentionInterval.components.seconds,
                    "receiveWaitTimeSeconds": 20,
                    "redrivePolicy": Resource.JSON([
                        "deadLetterTargetArn": deadLetterQueue.arn,
                        "maxReceiveCount": maxRetries + 1,
                    ]),
                ],
                options: options,
                context: context
            )
        }
    }
}

extension AWS.Queue {
    @discardableResult
    public func subscribe(
        _ function: AWS.Function,
        batchSize: Int = 1,
        maximumConcurrency: Int? = nil
    ) -> Self {
        function.link(self)

        let _ = Resource(
            name: "\(queue.chosenName)-subscription",
            type: "aws:lambda:EventSourceMapping",
            properties: [
                "eventSourceArn": queue.arn,
                "functionName": function.function.arn,
                "batchSize": batchSize,
                "scalingConfig": maximumConcurrency.map {
                    ["maximumConcurrency": $0]
                },
            ],
            options: function.function.options,
            context: function.function.context
        )

        return self
    }
}

extension AWS.Queue: Linkable {
    public var actions: [String] {
        [
            "sqs:SendMessage",
            "sqs:ReceiveMessage",
            "sqs:DeleteMessage",
            "sqs:GetQueueAttributes",
            "sqs:GetQueueUrl",
        ]
    }

    public var resources: [Output<String>] {
        [queue.arn]
    }

    public var properties: LinkProperties? {
        return .init(
            type: "queue",
            name: queue.chosenName,
            properties: [
                "name": name,
                "url": url,
            ]
        )
    }
}
