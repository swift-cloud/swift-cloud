extension aws {
    public struct Bucket: Component {
        internal let bucket: Resource
        internal let ownershipControls: Resource
        internal let publicAccessBlock: Resource

        public var bucketName: String {
            bucket.id
        }

        public init(_ name: String) {
            bucket = Resource(name, type: "aws:s3:Bucket")

            ownershipControls = Resource(
                "\(name)-ownershipControls",
                type: "aws:s3:BucketOwnershipControls",
                properties: [
                    "bucket": "\(bucket.ref)",
                    "rule": [
                        "objectOwnership": "ObjectWriter"
                    ],
                ]
            )

            publicAccessBlock = Resource(
                "\(name)-publicAccessBlock",
                type: "aws:s3:BucketPublicAccessBlock",
                properties: [
                    "bucket": "\(bucket.ref)",
                    "blockPublicAcls": false,
                ]
            )
        }
    }
}
