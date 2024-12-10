extension AWS {
    public struct ExpressBucket: AWSComponent {
        internal let bucket: Resource

        public let name: Output<String>

        public let availabilityZoneId: Output<String>

        public var region: Output<String> {
            getARN(bucket).region
        }

        public var hostname: Output<String> {
            "\(name).s3express-\(availabilityZoneId).\(region).amazonaws.com"
        }

        public init(
            _ name: String,
            vpc: VPC.Configuration,
            forceDestroy: Bool = true,
            options: Resource.Options? = nil
        ) {
            self.availabilityZoneId = getSubnet(vpc.subnetIds[0]).availabilityZoneId

            self.name = "\(tokenize(Context.current.stage, name))--\(availabilityZoneId)--x-s3"

            bucket = Resource(
                name: name,
                type: "aws:s3:DirectoryBucket",
                properties: [
                    "bucket": name,
                    "dataRedundancy": "SingleAvailabilityZone",
                    "forceDestroy": forceDestroy,
                    "type": "Directory",
                    "location": [
                        "name": availabilityZoneId,
                        "type": "AvailabilityZone",
                    ],
                ],
                options: options
            )
        }
    }
}

extension AWS.ExpressBucket: Linkable {
    public var actions: [String] {
        [
            "s3express:CreateSession",
            "s3express:PutObject",
            "s3express:GetObject",
            "s3express:DeleteObject",
            "s3express:ListBucket",
        ]
    }

    public var resources: [Output<String>] {
        [
            "\(bucket.arn)",
            "\(bucket.arn)/*",
        ]
    }

    public var environmentVariables: [String: Output<String>] {
        [
            "bucket \(bucket.chosenName) name": name,
            "bucket \(bucket.chosenName) hostname": hostname,
            "bucket \(bucket.chosenName) url": "https://\(hostname)",
        ]
    }
}
