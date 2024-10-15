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
            primaryIndex: PrimaryIndex,
            options: Resource.Options? = nil
        ) {
            table = Resource(
                name: name,
                type: "aws:dynamodb:Table",
                properties: [
                    "name": name,
                    "billingMode": "PAY_PER_REQUEST",
                    "hashKey": primaryIndex.hashKey.name,
                    "rangeKey": primaryIndex.rangeKey.name,
                    "attributes": [
                        ["name": primaryIndex.hashKey.name, "type": primaryIndex.hashKey.type.rawValue],
                        ["name": primaryIndex.rangeKey.name, "type": primaryIndex.rangeKey.type.rawValue],
                    ],
                ],
                options: options
            )
        }
    }
}

extension AWS.DynamoDB {
    public typealias IndexKey = (name: String, type: AttributeType)

    public struct PrimaryIndex: Sendable {
        public let hashKey: IndexKey
        public let rangeKey: IndexKey

        public init(hashKey: IndexKey, rangeKey: IndexKey) {
            self.hashKey = hashKey
            self.rangeKey = rangeKey
        }
    }

    public struct LocalIndex: Sendable {
        public let rangeKey: IndexKey

        public init(rangeKey: IndexKey) {
            self.rangeKey = rangeKey
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
