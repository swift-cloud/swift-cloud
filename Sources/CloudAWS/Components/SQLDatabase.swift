import CloudCore

extension AWS {
    public struct SQLDatabase: AWSComponent {
        public let engine: Engine

        public let cluster: Resource

        public let instances: [Resource]

        public let subnetGroup: Resource

        public let clusterParameterGroup: Resource

        public let masterUsername: String

        public struct MasterPasswordSecret { public let kmsKeyId: String, secretArn: String, secretStatus: String }
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
            engine: Engine,
            databaseName: String? = nil,
            scaling: ScalingConfiguration = .init(maximumConcurrency: 64),
            masterUsername: String = "swift",
            performanceInsightsEnabled: Bool = false,
            clusterParameters: [String: any Input<String>] = [:],
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

            clusterParameterGroup = Resource(
                name: "\(name)-cluster-pg",
                type: "aws:rds:ClusterParameterGroup",
                properties: [
                    "family": engine.parameterGroupFamily,
                    "parameters": clusterParameters.map {
                        [
                            "name": $0.key,
                            "value": $0.value,
                            "applyMethod": "pending-reboot",
                        ]
                    },
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
                    "allowMajorVersionUpgrade": false,
                    "storageEncrypted": true,
                    "skipFinalSnapshot": false,
                    "enableHttpEndpoint": true,
                    "finalSnapshotIdentifier": tokenize(context.stage, name, "final"),
                    "performanceInsightsEnabled": performanceInsightsEnabled,
                    "storageType": "aurora-iopt1",
                    "serverlessv2ScalingConfiguration": [
                        "minCapacity": scaling.minimumConcurrency,
                        "maxCapacity": scaling.maximumConcurrency,
                        "secondsUntilAutoPause": scaling.timeUntilAutoPause.components.seconds,
                    ],
                    "dbClusterParameterGroupName": clusterParameterGroup.name,
                    "dbSubnetGroupName": subnetGroupName,
                    "vpcSecurityGroupIds": vpc.securityGroupIds,
                ],
                options: options,
                context: context
            )

            let publiclyAccessible =
                switch vpc {
                case .public: true
                case .private: false
                }

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
                        "autoMinorVersionUpgrade": false,
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
                        "autoMinorVersionUpgrade": false,
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
        case postgres(_ version: PostgresVersion = .v16_6)
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

        public var parameterGroupFamily: String {
            switch self {
            case .mysql(let version):
                return version.parameterGroupFamily
            case .postgres(let version):
                return version.parameterGroupFamily
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
        case v16_6 = "16.6"
        case v16_4 = "16.4"
        case v15_8 = "15.8"
        case v14_13 = "14.13"

        public var parameterGroupFamily: String {
            switch self {
            case .v16_4, .v16_6:
                return "aurora-postgresql16"
            case .v15_8:
                return "aurora-postgresql15"
            case .v14_13:
                return "aurora-postgresql14"
            }
        }
    }

    public enum MySQLVersion: String, Sendable {
        case v8_0 = "8.0.mysql_aurora.3.08.0"
        case v5_7 = "5.7.mysql_aurora.2.12.4"

        public var parameterGroupFamily: String {
            switch self {
            case .v8_0:
                return "aurora-mysql8.0"
            case .v5_7:
                return "aurora-mysql5.7"
            }
        }
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
