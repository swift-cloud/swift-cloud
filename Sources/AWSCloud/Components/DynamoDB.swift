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
            options: Resource.Options? = nil
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
                ],
                options: options
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

    public var environmentVariables: [String: CustomStringConvertible] {
        [
            "dynamodb \(table.chosenName) name": name
        ]
    }
}
