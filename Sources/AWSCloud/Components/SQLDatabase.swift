import Cloud

extension AWS {
    public struct SQLDatabase: AWSComponent {
        public let cluster: Resource

        public let instance: Resource

        public let masterUsername: String

        public let masterPassword: Output<String>

        public var name: Output<String> {
            cluster.name
        }

        public let databaseName: String

        public var endpoint: Output<String> {
            cluster.output.keyPath("endpoint")
        }

        public var readerEndpoint: Output<String> {
            cluster.output.keyPath("readerEndpoint")
        }

        public init(
            _ name: String,
            engine: Engine = .postgres(),
            databaseName: String = Context.current.stage,
            masterUsername: String = "admin",
            vpc: VPC.Configuration,
            options: Resource.Options? = nil
        ) {
            self.databaseName = databaseName

            self.masterUsername = masterUsername

            masterPassword = Random.Bytes("\(name)-master-password", length: 16).hex

            let subnetGroup = Resource(
                name: "\(name)-sg",
                type: "aws:rds:SubnetGroup",
                properties: [
                    "name": tokenize(Context.current.stage, name, "default"),
                    "subnetIds": vpc.subnetIds,
                ],
                options: options
            )

            cluster = Resource(
                name: name,
                type: "aws:rds:Cluster",
                properties: [
                    "clusterIdentifier": tokenize(Context.current.stage, name),
                    "engine": engine.name,
                    "engineVersion": engine.version,
                    "engineMode": "provisioned",
                    "databaseName": databaseName,
                    "masterUsername": masterUsername,
                    "masterPassword": masterPassword,
                    "storageEncrypted": true,
                    "serverlessv2ScalingConfiguration": [
                        "minCapacity": 0.5,
                        "maxCapacity": 256,
                    ],
                    "dbSubnetGroupName": subnetGroup.output.keyPath("name"),
                    "vpcSecurityGroupIds": vpc.securityGroupIds,
                ],
                options: options
            )

            instance = Resource(
                name: "\(name)-instance",
                type: "aws:rds:ClusterInstance",
                properties: [
                    "clusterIdentifier": cluster.id,
                    "instanceClass": "db.serverless",
                    "engine": cluster.output.keyPath("engine"),
                    "engineVersion": cluster.output.keyPath("engineVersion"),
                ],
                options: options
            )
        }
    }
}

extension AWS.SQLDatabase {
    public enum Engine: Sendable {
        case postgres(_ version: PostgresVersion = .v16_4)
        case mysql(_ version: MySQLVersion = .v8_0)

        public var name: String {
            switch self {
            case .postgres:
                return "aurora-postgresql"
            case .mysql:
                return "aurora-mysql"
            }
        }

        public var version: String {
            switch self {
            case .postgres(let version):
                return version.rawValue
            case .mysql(let version):
                return version.rawValue
            }
        }
    }

    public enum PostgresVersion: String, Sendable {
        case v16_4 = "16.4"
        case v15_8 = "15.8"
        case v14_13 = "14.13"
    }

    public enum MySQLVersion: String, Sendable {
        case v8_0 = "8.0.mysql_aurora.3.08.0"
        case v5_7 = "5.7.mysql_aurora.2.12.4"
    }
}

extension AWS.SQLDatabase: Linkable {
    public var actions: [String] {
        [
            "rds-db:connect"
        ]
    }

    public var resources: [Output<String>] {
        [cluster.arn]
    }

    public var environmentVariables: [String: Output<String>] {
        [
            "sqldb \(cluster.chosenName) endpoint": self.endpoint,
            "sqldb \(cluster.chosenName) reader endpoint": self.readerEndpoint,
            "sqldb \(cluster.chosenName) database name": "\(self.databaseName)",
            "sqldb \(cluster.chosenName) username": "\(self.masterUsername)",
            "sqldb \(cluster.chosenName) password": self.masterPassword,
        ]
    }
}
