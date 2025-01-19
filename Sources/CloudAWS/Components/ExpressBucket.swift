extension AWS {
    public struct ExpressBucket: AWSComponent {
        internal let bucket: Resource

        public var name: Output<String>

        public let availabilityZoneId: any Input<String>

        public var region: Output<String> {
            getARN(bucket).region
        }

        public var hostname: Output<String> {
            "\(name).s3express-\(availabilityZoneId).\(region).amazonaws.com"
        }

        public init(
            _ chosenName: String,
            availabilityZoneId azId: (any Input<String>)? = nil,
            vpc: VPC? = nil,
            forceDestroy: Bool = true,
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            self.availabilityZoneId = azId ?? Self.availabilityZones.output.keyPath(context.region)[0]

            let suffix = Random.Text(
                "\(chosenName)-suffix",
                length: 6,
                casing: [.lower]
            )

            self.name =
                "\(tokenize(context.stage, chosenName))-\(suffix.value)--\(availabilityZoneId)--x-s3"

            bucket = Resource(
                name: chosenName,
                type: "aws:s3:DirectoryBucket",
                properties: [
                    "bucket": name,
                    "dataRedundancy": "SingleAvailabilityZone",
                    "forceDestroy": forceDestroy,
                    "type": "Directory",
                    "location": [
                        "name": self.availabilityZoneId,
                        "type": "AvailabilityZone",
                    ],
                ],
                options: options,
                context: context
            )
        }
    }
}

extension AWS.ExpressBucket {
    public static let availabilityZones: Variable<[String: [String]]> = .init(
        name: "s3-express-azs",
        definition: [
            "us-east-1": ["use1-az4", "use1-az5", "use1-az6"],
            "us-east-2": ["use2-az1", "use2-az2"],
            "us-west-2": ["usw2-az1", "usw2-az3", "usw2-az4"],
            "ap-south-1": ["aps1-az1", "aps1-az3"],
            "ap-northeast-1": ["apne1-az1", "apne1-az4"],
            "eu-west-1": ["euw1-az1", "euw1-az3"],
            "eu-north-1": ["eun1-az1", "eun1-az2", "eun1-az3"],
        ]
    )
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

    public var properties: LinkProperties? {
        return .init(
            type: "bucket",
            name: bucket.chosenName,
            properties: [
                "name": name,
                "hostname": hostname,
                "url": "https://\(hostname)",
            ]
        )
    }
}
