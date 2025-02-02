extension AWS {
    public struct DynamoDB: AWSComponent {
        public let table: Resource

        public var name: Output<String> {
            table.name
        }

        public var id: Output<String> {
            table.id
        }

        public init(
            _ name: String,
            primaryIndex: Index,
            secondaryIndexes: [Index] = [],
            streaming: StreamingConfiguration = .disabled,
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            table = Resource(
                name: name,
                type: "aws:dynamodb:Table",
                properties: [
                    "billingMode": "PAY_PER_REQUEST",
                    "hashKey": primaryIndex.partitionKey.name,
                    "rangeKey": primaryIndex.sortKey?.name,
                    "attributes": [
                        ["name": primaryIndex.partitionKey.name, "type": primaryIndex.partitionKey.type.rawValue],
                        primaryIndex.sortKey.map { ["name": $0.name, "type": $0.type.rawValue] },
                    ].compactMap { $0 },
                    "globalSecondaryIndexes": secondaryIndexes.map { index in
                        [
                            "name": index.partitionKey.name,
                            "projectionType": "ALL",
                            "hashKey": index.partitionKey.name,
                            "rangeKey": index.sortKey?.name,
                        ]
                    },
                    "streamEnabled": streaming != .disabled,
                    "streamViewType": streaming == .disabled ? nil : streaming.rawValue,
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
    public enum StreamingConfiguration: String, Sendable {
        case disabled = "DISABLED"
        case keysOnly = "KEYS_ONLY"
        case oldImage = "OLD_IMAGE"
        case newImage = "NEW_IMAGE"
        case newAndOldImages = "NEW_AND_OLD_IMAGES"
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
        function.link(self)

        let _ = Resource(
            name: "\(table.chosenName)-subscription",
            type: "aws:lambda:EventSourceMapping",
            properties: [
                "eventSourceArn": table.output.keyPath("streamArn"),
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
            "dynamodb:Query",
            "dynamodb:Scan",
        ]
    }

    public var resources: [Output<String>] {
        [table.arn]
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
