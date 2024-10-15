extension AWS {
    public struct Bucket: AWSComponent {
        internal let bucket: Resource
        internal let ownershipControls: Resource
        internal let publicAccessBlock: Resource

        public var name: Output<String> {
            bucket.id
        }

        public var region: Output<String> {
            getARN(bucket).region
        }

        public var hostname: Output<String> {
            bucket.output.keyPath("bucketRegionalDomainName")
        }

        public init(
            _ name: String,
            forceDestroy: Bool = true,
            options: Resource.Options? = nil
        ) {
            bucket = Resource(
                name: name,
                type: "aws:s3:Bucket",
                properties: [
                    "forceDestroy": forceDestroy
                ],
                options: options
            )

            ownershipControls = Resource(
                name: "\(name)-oc",
                type: "aws:s3:BucketOwnershipControls",
                properties: [
                    "bucket": bucket.output,
                    "rule": [
                        "objectOwnership": "ObjectWriter"
                    ],
                ],
                options: options
            )

            publicAccessBlock = Resource(
                name: "\(name)-pab",
                type: "aws:s3:BucketPublicAccessBlock",
                properties: [
                    "bucket": bucket.output,
                    "blockPublicAcls": false,
                ],
                options: options
            )
        }
    }
}

extension AWS.Bucket: Linkable {
    public var actions: [String] {
        [
            "s3:PutObject",
            "s3:GetObject",
            "s3:DeleteObject",
            "s3:ListBucket",
        ]
    }

    public var resources: [Output<String>] {
        [
            "\(bucket.arn)",
            "\(bucket.arn)/*",
        ]
    }

    public var environmentVariables: [String: Input<String>] {
        [
            "bucket \(bucket.chosenName) name": .init(name),
            "bucket \(bucket.chosenName) hostname": .init(hostname),
            "bucket \(bucket.chosenName) url": "https://\(hostname)",
        ]
    }
}
