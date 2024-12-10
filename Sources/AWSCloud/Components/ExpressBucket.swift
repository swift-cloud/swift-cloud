extension AWS {
    public struct ExpressBucket: AWSComponent {
        internal let bucket: Resource

        public var name: Output<String>

        public let availabilityZoneId: Output<String>

        public var region: Output<String> {
            getARN(bucket).region
        }

        public var hostname: Output<String> {
            "\(name).s3express-\(availabilityZoneId).\(region).amazonaws.com"
        }

        public init(
            _ chosenName: String,
            vpc: VPC.Configuration,
            forceDestroy: Bool = true,
            options: Resource.Options? = nil
        ) {
            self.availabilityZoneId = getSubnet(vpc.subnetIds[2]).availabilityZoneId

            self.name = "\(tokenize(Context.current.stage, chosenName))--\(availabilityZoneId)--x-s3"

            bucket = Resource(
                name: chosenName,
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
            "s3express:CreateSession"
        ]
    }

    public var resources: [Output<String>] {
        [
            "\(bucket.arn)"
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
