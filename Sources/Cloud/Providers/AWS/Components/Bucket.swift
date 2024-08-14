extension AWS {
    public struct Bucket: Component {
        internal let bucket: Resource
        internal let ownershipControls: Resource
        internal let publicAccessBlock: Resource

        public var name: String {
            bucket.id
        }

        public var hostname: String {
            bucket.keyPath("bucketRegionalDomainName")
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
                    "bucket": "\(bucket.ref)",
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
                    "bucket": "\(bucket.ref)",
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

    public var resources: [String] {
        [
            "\(bucket.arn)",
            "\(bucket.arn)/*",
        ]
    }

    public var environmentVariables: [String: String] {
        [
            "bucket_\(tokenize(bucket.chosenName))_name": name,
            "bucket_\(tokenize(bucket.chosenName))_hostname": hostname,
            "bucket_\(tokenize(bucket.chosenName))_url": "https://\(hostname)",
        ]
    }
}
