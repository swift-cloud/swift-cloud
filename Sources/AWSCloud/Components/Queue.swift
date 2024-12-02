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
            options: Resource.Options? = nil
        ) {
            deadLetterQueue = Resource(
                name: "\(name)-dlq",
                type: "aws:sqs:Queue",
                properties: [
                    "fifoQueue": fifo,
                    "visibilityTimeoutSeconds": visibilityTimeout.components.seconds,
                    "messageRetentionSeconds": 1_209_600,
                ],
                options: options
            )

            queue = Resource(
                name: name,
                type: "aws:sqs:Queue",
                properties: [
                    "fifoQueue": fifo,
                    "visibilityTimeoutSeconds": visibilityTimeout.components.seconds,
                    "messageRetentionSeconds": messageRetentionInterval.components.seconds,
                    "redrivePolicy": Resource.JSON([
                        "deadLetterTargetArn": deadLetterQueue.arn,
                        "maxReceiveCount": maxRetries + 1,
                    ]),
                ],
                options: options
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
    ) -> AWS.Queue {
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
            options: function.function.options
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

    public var environmentVariables: [String: Output<String>] {
        [
            "queue \(queue.chosenName) name": name,
            "queue \(queue.chosenName) url": url,
        ]
    }
}
