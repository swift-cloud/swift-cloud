import CloudCore

extension AWS {
    public struct SQLDatabase: AWSComponent {
        public let engine: Engine

        public let cluster: Resource

        public let instances: [Resource]

        public let subnetGroup: Resource

        public let masterUsername: String

        public typealias MasterPasswordSecret = (kmsKeyId: String, secretArn: String, secretStatus: String)
        public var masterPasswordSecret: Output<MasterPasswordSecret> {
            cluster.output.keyPath("masterUserSecrets")[0]
        }

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
            return "\(engine.scheme)://\(masterUsername)@\(hostname):\(port)/\(databaseName)"
        }

        public init(
            _ name: String,
            engine: Engine = .postgres(),
            databaseName: String? = nil,
            scaling: ScalingConfiguration = .init(maximumConcurrency: 64),
            masterUsername: String = "swift",
            publiclyAccessible: Bool = false,
            performanceInsightsEnabled: Bool = false,
            vpc: VPC.Configuration,
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            self.engine = engine

            self.databaseName = databaseName ?? context.stage

            self.masterUsername = masterUsername

            let subnetGroupName = tokenize(context.stage, name, "default")

            subnetGroup = Resource(
                name: "\(name)-sg",
                type: "aws:rds:SubnetGroup",
                properties: [
                    "name": subnetGroupName,
                    "subnetIds": vpc.subnetIds,
                ],
                options: options,
                context: context
            )

            let clusterIdentifier = tokenize(context.stage, name)

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
                    "manageMasterUserPassword": true,
                    "iamDatabaseAuthenticationEnabled": true,
                    "applyImmediately": true,
                    "allowMajorVersionUpgrade": true,
                    "storageEncrypted": true,
                    "skipFinalSnapshot": false,
                    "enableHttpEndpoint": true,
                    "finalSnapshotIdentifier": tokenize(context.stage, name, "final"),
                    "performanceInsightsEnabled": performanceInsightsEnabled,
                    "serverlessv2ScalingConfiguration": [
                        "minCapacity": scaling.minimumConcurrency,
                        "maxCapacity": scaling.maximumConcurrency,
                        "secondsUntilAutoPause": scaling.timeUntilAutoPause.components.seconds,
                    ],
                    "dbSubnetGroupName": subnetGroupName,
                    "vpcSecurityGroupIds": vpc.securityGroupIds,
                ],
                options: options,
                context: context
            )

            instances = [
                Resource(
                    name: "\(name)-instance-1",
                    type: "aws:rds:ClusterInstance",
                    properties: [
                        "clusterIdentifier": clusterIdentifier,
                        "instanceClass": "db.serverless",
                        "engine": engine.name,
                        "engineVersion": engine.version,
                        "applyImmediately": true,
                        "autoMinorVersionUpgrade": true,
                        "promotionTier": 0,
                        "publiclyAccessible": publiclyAccessible,
                    ],
                    options: options,
                    context: context,
                    dependsOn: [cluster]
                ),
                Resource(
                    name: "\(name)-instance-2",
                    type: "aws:rds:ClusterInstance",
                    properties: [
                        "clusterIdentifier": clusterIdentifier,
                        "instanceClass": "db.serverless",
                        "engine": engine.name,
                        "engineVersion": engine.version,
                        "applyImmediately": true,
                        "autoMinorVersionUpgrade": true,
                        "promotionTier": 0,
                        "publiclyAccessible": publiclyAccessible,
                    ],
                    options: options,
                    context: context,
                    dependsOn: [cluster]
                ),
            ]
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

extension AWS.SQLDatabase {
    public struct ScalingConfiguration: Sendable {
        public let minimumConcurrency: Int
        public let maximumConcurrency: Int
        public let timeUntilAutoPause: Duration

        public init(
            minimumConcurrency: Int = 0,
            maximumConcurrency: Int,
            timeUntilAutoPause: Duration = .seconds(300)
        ) {
            self.minimumConcurrency = minimumConcurrency
            self.maximumConcurrency = maximumConcurrency
            self.timeUntilAutoPause = timeUntilAutoPause
        }
    }
}

extension AWS.SQLDatabase: Linkable {
    public var actions: [String] {
        [
            "rds-db:connect"
        ]
    }

    public var resources: [Output<String>] {
        ["\(cluster.arn)/\(masterUsername)"]
    }

    public var properties: LinkProperties? {
        return .init(
            type: "sqldb",
            name: cluster.chosenName,
            properties: [
                "hostname": hostname,
                "port": port,
                "databaseName": databaseName,
                "username": masterUsername,
                "url": url,
            ]
        )
    }
}
