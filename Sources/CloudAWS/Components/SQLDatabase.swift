import CloudCore

extension AWS {
    public struct SQLDatabase: AWSComponent {
        public let engine: Engine

        public let cluster: Resource

        public let instance: Resource

        public let subnetGroup: Resource

        public let masterUsername: String

        public let masterPassword: Output<String>

        public var name: Output<String> {
            cluster.name
        }

        public let databaseName: String

        public var hostname: Output<String> {
            cluster.output.keyPath("endpoint")
        }

        public var port: Output<String> {
            "\(engine.port)"
        }

        public var url: Output<String> {
            return "\(engine.scheme)://\(masterUsername):\(masterPassword)@\(hostname):\(port)/\(databaseName)"
        }

        public init(
            _ name: String,
            engine: Engine = .postgres(),
            databaseName: String = Context.current.stage,
            masterUsername: String = "swift",
            vpc: VPC.Configuration,
            options: Resource.Options? = nil
        ) {
            self.engine = engine

            self.databaseName = databaseName

            self.masterUsername = masterUsername

            masterPassword = Random.Bytes("\(name)-master-password", length: 16).hex

            let subnetGroupName = tokenize(Context.current.stage, name, "default")

            subnetGroup = Resource(
                name: "\(name)-sg",
                type: "aws:rds:SubnetGroup",
                properties: [
                    "name": subnetGroupName,
                    "subnetIds": vpc.subnetIds,
                ],
                options: options
            )

            let clusterIdentifier = tokenize(Context.current.stage, name)

            cluster = Resource(
                name: name,
                type: "aws:rds:Cluster",
                properties: [
                    "clusterIdentifier": clusterIdentifier,
                    "engine": engine.name,
                    "engineVersion": engine.version,
                    "port": engine.port,
                    "engineMode": "provisioned",
                    "databaseName": databaseName,
                    "masterUsername": masterUsername,
                    "masterPassword": masterPassword,
                    "storageEncrypted": true,
                    "serverlessv2ScalingConfiguration": [
                        "minCapacity": 0.5,
                        "maxCapacity": 256,
                    ],
                    "dbSubnetGroupName": subnetGroupName,
                    "vpcSecurityGroupIds": vpc.securityGroupIds,
                ],
                options: options
            )

            instance = Resource(
                name: "\(name)-instance",
                type: "aws:rds:ClusterInstance",
                properties: [
                    "clusterIdentifier": clusterIdentifier,
                    "instanceClass": "db.serverless",
                    "engine": engine.name,
                    "engineVersion": engine.version,
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

        public var scheme: String {
            switch self {
            case .postgres:
                return "postgres"
            case .mysql:
                return "mysql"
            }
        }

        public var port: Int {
            switch self {
            case .postgres:
                return 5432
            case .mysql:
                return 3306
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
            "sqldb \(cluster.chosenName) hostname": self.hostname,
            "sqldb \(cluster.chosenName) port": self.port,
            "sqldb \(cluster.chosenName) database name": "\(self.databaseName)",
            "sqldb \(cluster.chosenName) username": "\(self.masterUsername)",
            "sqldb \(cluster.chosenName) password": self.masterPassword,
            "sqldb \(cluster.chosenName) url": self.url,
        ]
    }
}
