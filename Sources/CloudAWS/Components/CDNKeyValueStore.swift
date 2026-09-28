import Foundation

extension AWS.CDN {
    /// A CloudFront KeyValueStore: a small global key-value store replicated to every edge location,
    /// readable from CloudFront Functions and writable through the `cloudfront-keyvaluestore` API.
    public struct KeyValueStore: AWSComponent {
        public let store: Resource

        public var name: Output<String> {
            store.name
        }

        public var arn: Output<String> {
            store.arn
        }

        public var id: Output<String> {
            store.id
        }

        public init(
            _ name: String,
            comment: String? = nil,
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            store = Resource(
                name: name,
                type: "aws:cloudfront:KeyValueStore",
                properties: [
                    // Store names allow up to 64 characters.
                    "name": tokenize(context.stage, name, maxLength: 64),
                    "comment": comment,
                ],
                options: options,
                context: context
            )
        }
    }
}

extension AWS.CDN.KeyValueStore: Linkable {
    public var actions: [String] {
        [
            "cloudfront-keyvaluestore:DescribeKeyValueStore",
            "cloudfront-keyvaluestore:GetKey",
            "cloudfront-keyvaluestore:ListKeys",
            "cloudfront-keyvaluestore:PutKey",
            "cloudfront-keyvaluestore:DeleteKey",
            "cloudfront-keyvaluestore:UpdateKeys",
        ]
    }

    public var resources: [Output<String>] {
        [arn]
    }

    public var properties: LinkProperties? {
        return .init(
            type: "keyvaluestore",
            name: store.chosenName,
            properties: [
                "name": name,
                "arn": arn,
            ]
        )
    }
}
