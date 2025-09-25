extension AWS {
    public struct DynamoDB: AWSComponent {
        public let table: Resource

        public let streaming: StreamingConfiguration

        public var name: Output<String> {
            table.name
        }

        public var id: Output<String> {
            table.id
        }

        fileprivate var streamArn: Output<String>? {
            guard streaming.isEnabled else {
                return nil
            }
            return table.output.keyPath("streamArn")
        }

        public init(
            _ name: String,
            primaryIndex: Index,
            secondaryIndexes: [Index] = [],
            streaming: StreamingConfiguration = .disabled,
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            self.streaming = streaming

            table = Resource(
                name: name,
                type: "aws:dynamodb:Table",
                properties: [
                    "billingMode": "PAY_PER_REQUEST",
                    "hashKey": primaryIndex.partitionKey.name,
                    "rangeKey": primaryIndex.sortKey?.name,
                    "attributes": ([primaryIndex] + secondaryIndexes).asAttributes,
                    "globalSecondaryIndexes": secondaryIndexes.map { index in
                        [
                            "name": index.partitionKey.name,
                            "projectionType": "ALL",
                            "hashKey": index.partitionKey.name,
                            "rangeKey": index.sortKey?.name,
                        ]
                    },
                    "streamEnabled": streaming.isEnabled,
                    "streamViewType": streaming.viewType?.rawValue,
                ],
                options: options,
                context: context
            )
        }
    }
}

extension AWS.DynamoDB {
    public typealias IndexKey = (name: String, type: AttributeType)

    public struct Index: Sendable {
        public let partitionKey: IndexKey
        public let sortKey: IndexKey?

        public init(partitionKey: IndexKey, sortKey: IndexKey? = nil) {
            self.partitionKey = partitionKey
            self.sortKey = sortKey
        }
    }
}

extension AWS.DynamoDB {
    public enum AttributeType: String, Sendable {
        case string = "S"
        case number = "N"
        case binary = "B"
    }
}

extension AWS.DynamoDB {
    public enum StreamingConfiguration: Sendable {
        public enum StreamViewType: String, Sendable {
            case keysOnly = "KEYS_ONLY"
            case oldImage = "OLD_IMAGE"
            case newImage = "NEW_IMAGE"
            case newAndOldImages = "NEW_AND_OLD_IMAGES"
        }

        case disabled
        case enabled(viewType: StreamViewType = .newImage)

        public var isEnabled: Bool {
            switch self {
            case .disabled:
                return false
            case .enabled:
                return true
            }
        }

        public var viewType: StreamViewType? {
            switch self {
            case .disabled:
                return nil
            case .enabled(let viewType):
                return viewType
            }
        }
    }
}

extension AWS.DynamoDB {
    public enum SubscriptionStartingPosition: String, Sendable {
        case latest = "LATEST"
        case trimHorizon = "TRIM_HORIZON"
    }

    @discardableResult
    public func subscribe(
        _ function: AWS.Function,
        batchSize: Int = 1,
        startingPosition: SubscriptionStartingPosition = .latest
    ) -> Self {
        guard let streamArn else {
            fatalError("DynamoDB table does not have streaming enabled")
        }

        function.link(self)

        function.grantInvokePermission(
            name: table.chosenName,
            arn: streamArn,
            principal: "dynamodb.amazonaws.com"
        )

        let _ = Resource(
            name: "\(table.chosenName)-subscription",
            type: "aws:lambda:EventSourceMapping",
            properties: [
                "eventSourceArn": streamArn,
                "functionName": function.function.arn,
                "batchSize": batchSize,
                "startingPosition": startingPosition.rawValue,
            ],
            options: function.function.options,
            context: function.function.context
        )

        return self
    }
}

extension AWS.DynamoDB: Linkable {
    public var actions: [String] {
        [
            "dynamodb:PutItem",
            "dynamodb:GetItem",
            "dynamodb:UpdateItem",
            "dynamodb:DeleteItem",
            "dynamodb:BatchWriteItem",
            "dynamodb:BatchGetItem",
            "dynamodb:Query",
            "dynamodb:Scan",
            "dynamodb:GetRecords",
            "dynamodb:GetShardIterator",
            "dynamodb:DescribeStream",
            "dynamodb:ListStreams",
        ]
    }

    public var resources: [Output<String>] {
        [
            table.arn,
            "\(table.arn)/*",
            streamArn
        ].compactMap { $0 }
    }

    public var properties: LinkProperties? {
        return .init(
            type: "dynamodb",
            name: table.chosenName,
            properties: [
                "name": name
            ]
        )
    }
}

private extension AWS.DynamoDB.Index {
    var asAttributes: [[String: String]] {
        [
            ["name": partitionKey.name, "type": partitionKey.type.rawValue],
            sortKey.map { ["name": $0.name, "type": $0.type.rawValue] },
        ].compactMap { $0 }
    }
}

private extension [AWS.DynamoDB.Index] {
    var asAttributes: [[String: String]] {
        flatMap(\.asAttributes)
    }
}
