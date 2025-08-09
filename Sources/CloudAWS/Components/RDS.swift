import CloudCore

extension AWS {
    public struct RDS: AWSComponent {
        public let engine: Engine

        public let instance: Resource

        public let subnetGroup: Resource

        public let parameterGroupResource: Resource

        public let optionGroup: Resource?

        public let instanceClass: InstanceClass

        public let storage: StorageConfiguration

        public let masterUsername: String

        public struct MasterPasswordSecret { public let kmsKeyId: String, secretArn: String, secretStatus: String }
        public var masterPasswordSecret: Output<MasterPasswordSecret> {
            instance.output.keyPath("masterUserSecrets")[0]
        }

        public var name: Output<String> {
            instance.name
        }

        public let databaseName: String

        public var hostname: Output<String> {
            instance.output.keyPath("endpoint")
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
            instanceClass: InstanceClass = .t3_micro,
            storage: StorageConfiguration = .init(),
            masterUsername: String = "swift",
            multiAZ: Bool = false,
            backupConfiguration: BackupConfiguration = .init(),
            maintenanceWindow: MaintenanceWindow = .init(),
            parameterGroup: ParameterGroupConfiguration? = nil,
            performanceInsightsEnabled: Bool = false,
            monitoringInterval: Int = 0,
            deletionProtection: Bool = true,
            vpc: VPC.Configuration,
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            self.engine = engine

            self.instanceClass = instanceClass

            self.storage = storage

            self.databaseName = databaseName ?? context.stage
            
            self.masterUsername = masterUsername

            let instanceIdentifier = tokenize(context.stage, name)
            let subnetGroupName = tokenize(context.stage, name, "subnet-group")
            let parameterGroupName = tokenize(context.stage, name, "params")
            let optionGroupName = tokenize(context.stage, name, "options")

            let publiclyAccessible =
                switch vpc {
                case .public: true
                case .private: false
                }

            var securityGroupIds = [vpc.securityGroupId]

            if publiclyAccessible {
                let securityGroup = AWS.SecurityGroup(
                    "\(name)-public-sg",
                    ingress: .all,
                    egress: .all,
                    options: options,
                    context: context
                )
                securityGroupIds.append(securityGroup.id)
            }

            // Create subnet group
            subnetGroup = Resource(
                name: "\(name)-subnet-group",
                type: "aws:rds:SubnetGroup",
                properties: [
                    "name": subnetGroupName,
                    "subnetIds": vpc.subnetIds,
                    "tags": ["Name": subnetGroupName],
                ],
                options: options,
                context: context
            )

            // Create parameter group
            parameterGroupResource = Resource(
                name: "\(name)-parameter-group",
                type: "aws:rds:ParameterGroup",
                properties: [
                    "name": parameterGroupName,
                    "family": engine.parameterGroupFamily,
                    "parameters": (parameterGroup?.parameters ?? [:]).map {
                        [
                            "name": $0.key,
                            "value": $0.value,
                            "applyMethod": "immediate",
                        ]
                    },
                    "tags": ["Name": parameterGroupName],
                ],
                options: options,
                context: context
            )

            // Create option group for engines that support it
            if engine.supportsOptionGroups {
                optionGroup = Resource(
                    name: "\(name)-option-group",
                    type: "aws:rds:OptionGroup",
                    properties: [
                        "name": optionGroupName,
                        "engineName": engine.name,
                        "majorEngineVersion": engine.majorVersion,
                        "tags": ["Name": optionGroupName],
                    ],
                    options: options,
                    context: context
                )
            } else {
                optionGroup = nil
            }

            // Create main RDS instance
            instance = Resource(
                name: name,
                type: "aws:rds:Instance",
                properties: [
                    "identifier": instanceIdentifier,
                    "engine": engine.name,
                    "engineVersion": engine.version,
                    "instanceClass": instanceClass.rawValue,
                    "allocatedStorage": storage.size,
                    "storageType": storage.type.rawValue,
                    "storageEncrypted": storage.encrypted,
                    "iops": storage.type.supportsIOPS ? storage.iops : nil,
                    "storageThroughput": storage.type.supportsThroughput ? storage.throughput : nil,
                    "dbName": engine.supportsInitialDatabase ? databaseName : nil,
                    "username": masterUsername,
                    "manageMasterUserPassword": true,
                    "port": engine.port,
                    "publiclyAccessible": publiclyAccessible,
                    "multiAz": multiAZ,
                    "dbSubnetGroupName": subnetGroupName,
                    "vpcSecurityGroupIds": securityGroupIds,
                    "parameterGroupName": parameterGroupName,
                    "optionGroupName": optionGroup?.name,
                    "backupRetentionPeriod": backupConfiguration.retentionPeriod,
                    "backupWindow": backupConfiguration.window,
                    "maintenanceWindow": maintenanceWindow.window,
                    "autoMinorVersionUpgrade": maintenanceWindow.autoMinorVersionUpgrade,
                    "performanceInsightsEnabled": performanceInsightsEnabled,
                    "monitoringInterval": monitoringInterval,
                    "deletionProtection": deletionProtection,
                    "skipFinalSnapshot": !backupConfiguration.finalSnapshot,
                    "finalSnapshotIdentifier": backupConfiguration.finalSnapshot
                        ? tokenize(context.stage, name, "final") : nil,
                    "applyImmediately": true,
                    "tags": ["Name": instanceIdentifier],
                ],
                options: options,
                context: context,
                dependsOn: [subnetGroup, parameterGroupResource, optionGroup].compactMap { $0 }
            )

        }
    }
}

extension AWS.RDS {
    public enum Engine: Sendable {
        case postgres(_ version: PostgresVersion = .v16_6)
        case mysql(_ version: MySQLVersion = .v8_0)
        case mariadb(_ version: MariaDBVersion = .v10_11)
        case oracle(_ version: OracleVersion = .v19c)
        case sqlserver(_ version: SQLServerVersion = .v2022)

        public var name: String {
            switch self {
            case .postgres: return "postgres"
            case .mysql: return "mysql"
            case .mariadb: return "mariadb"
            case .oracle: return "oracle-ee"
            case .sqlserver: return "sqlserver-se"
            }
        }

        public var version: String {
            switch self {
            case .postgres(let version): return version.rawValue
            case .mysql(let version): return version.rawValue
            case .mariadb(let version): return version.rawValue
            case .oracle(let version): return version.rawValue
            case .sqlserver(let version): return version.rawValue
            }
        }

        public var majorVersion: String {
            switch self {
            case .postgres(let version): return version.majorVersion
            case .mysql(let version): return version.majorVersion
            case .mariadb(let version): return version.majorVersion
            case .oracle(let version): return version.majorVersion
            case .sqlserver(let version): return version.majorVersion
            }
        }

        public var parameterGroupFamily: String {
            switch self {
            case .postgres(let version): return version.parameterGroupFamily
            case .mysql(let version): return version.parameterGroupFamily
            case .mariadb(let version): return version.parameterGroupFamily
            case .oracle(let version): return version.parameterGroupFamily
            case .sqlserver(let version): return version.parameterGroupFamily
            }
        }

        public var scheme: String {
            switch self {
            case .postgres: return "postgres"
            case .mysql, .mariadb: return "mysql"
            case .oracle: return "oracle"
            case .sqlserver: return "sqlserver"
            }
        }

        public var port: Int {
            switch self {
            case .postgres: return 5432
            case .mysql, .mariadb: return 3306
            case .oracle: return 1521
            case .sqlserver: return 1433
            }
        }

        public var supportsOptionGroups: Bool {
            switch self {
            case .postgres, .mariadb: return false
            case .mysql, .oracle, .sqlserver: return true
            }
        }
        
        public var supportsInitialDatabase: Bool {
            switch self {
            case .postgres, .mysql, .mariadb: return true
            case .oracle, .sqlserver: return false // These engines don't support dbName parameter
            }
        }
    }

    public enum PostgresVersion: String, Sendable {
        case v16_6 = "16.6"
        case v16_4 = "16.4"
        case v15_8 = "15.8"
        case v14_13 = "14.13"
        case v13_16 = "13.16"

        public var majorVersion: String {
            switch self {
            case .v16_4, .v16_6: return "16"
            case .v15_8: return "15"
            case .v14_13: return "14"
            case .v13_16: return "13"
            }
        }

        public var parameterGroupFamily: String {
            "postgres\(majorVersion)"
        }
    }

    public enum MySQLVersion: String, Sendable {
        case v8_0 = "8.0.39"
        case v8_0_35 = "8.0.35"
        case v5_7 = "5.7.44"

        public var majorVersion: String {
            switch self {
            case .v8_0, .v8_0_35: return "8.0"
            case .v5_7: return "5.7"
            }
        }

        public var parameterGroupFamily: String {
            "mysql\(majorVersion)"
        }
    }

    public enum MariaDBVersion: String, Sendable {
        case v10_11 = "10.11.8"
        case v10_6 = "10.6.18"
        case v10_5 = "10.5.25"

        public var majorVersion: String {
            switch self {
            case .v10_11: return "10.11"
            case .v10_6: return "10.6"
            case .v10_5: return "10.5"
            }
        }

        public var parameterGroupFamily: String {
            "mariadb\(majorVersion)"
        }
    }

    public enum OracleVersion: String, Sendable {
        case v19c = "19.0.0.0.ru-2024-07.rur-2024-07.r1"
        case v12c = "12.2.0.1.ru-2024-07.rur-2024-07.r1"

        public var majorVersion: String {
            switch self {
            case .v19c: return "19"
            case .v12c: return "12.2"
            }
        }

        public var parameterGroupFamily: String {
            "oracle-ee-\(majorVersion)"
        }
    }

    public enum SQLServerVersion: String, Sendable {
        case v2022 = "16.00.4095.4.v1"
        case v2019 = "15.00.4365.2.v1"

        public var majorVersion: String {
            switch self {
            case .v2022: return "16.0"
            case .v2019: return "15.0"
            }
        }

        public var parameterGroupFamily: String {
            "sqlserver-se-\(majorVersion)"
        }
    }
}

extension AWS.RDS {
    public enum InstanceClass: String, Sendable {
        // Burstable Performance
        case t3_micro = "db.t3.micro"
        case t3_small = "db.t3.small"
        case t3_medium = "db.t3.medium"
        case t3_large = "db.t3.large"
        case t3_xlarge = "db.t3.xlarge"
        case t3_2xlarge = "db.t3.2xlarge"

        case t4g_micro = "db.t4g.micro"
        case t4g_small = "db.t4g.small"
        case t4g_medium = "db.t4g.medium"
        case t4g_large = "db.t4g.large"
        case t4g_xlarge = "db.t4g.xlarge"
        case t4g_2xlarge = "db.t4g.2xlarge"

        // General Purpose
        case m5_large = "db.m5.large"
        case m5_xlarge = "db.m5.xlarge"
        case m5_2xlarge = "db.m5.2xlarge"
        case m5_4xlarge = "db.m5.4xlarge"
        case m5_8xlarge = "db.m5.8xlarge"
        case m5_12xlarge = "db.m5.12xlarge"
        case m5_16xlarge = "db.m5.16xlarge"
        case m5_24xlarge = "db.m5.24xlarge"

        case m6i_large = "db.m6i.large"
        case m6i_xlarge = "db.m6i.xlarge"
        case m6i_2xlarge = "db.m6i.2xlarge"
        case m6i_4xlarge = "db.m6i.4xlarge"
        case m6i_8xlarge = "db.m6i.8xlarge"
        case m6i_12xlarge = "db.m6i.12xlarge"
        case m6i_16xlarge = "db.m6i.16xlarge"
        case m6i_24xlarge = "db.m6i.24xlarge"
        case m6i_32xlarge = "db.m6i.32xlarge"

        // Memory Optimized
        case r5_large = "db.r5.large"
        case r5_xlarge = "db.r5.xlarge"
        case r5_2xlarge = "db.r5.2xlarge"
        case r5_4xlarge = "db.r5.4xlarge"
        case r5_8xlarge = "db.r5.8xlarge"
        case r5_12xlarge = "db.r5.12xlarge"
        case r5_16xlarge = "db.r5.16xlarge"
        case r5_24xlarge = "db.r5.24xlarge"

        case r6i_large = "db.r6i.large"
        case r6i_xlarge = "db.r6i.xlarge"
        case r6i_2xlarge = "db.r6i.2xlarge"
        case r6i_4xlarge = "db.r6i.4xlarge"
        case r6i_8xlarge = "db.r6i.8xlarge"
        case r6i_12xlarge = "db.r6i.12xlarge"
        case r6i_16xlarge = "db.r6i.16xlarge"
        case r6i_24xlarge = "db.r6i.24xlarge"
        case r6i_32xlarge = "db.r6i.32xlarge"
    }
}

extension AWS.RDS {
    public struct StorageConfiguration: Sendable {
        public let type: StorageType
        public let size: Int
        public let encrypted: Bool
        public let iops: Int?
        public let throughput: Int?

        public init(
            type: StorageType = .gp3,
            size: Int = 20,
            encrypted: Bool = true,
            iops: Int? = nil,
            throughput: Int? = nil
        ) {
            self.type = type
            self.size = size
            self.encrypted = encrypted
            self.iops = iops
            self.throughput = throughput
        }
    }

    public enum StorageType: String, Sendable {
        case standard = "standard"
        case gp2 = "gp2"
        case gp3 = "gp3"
        case io1 = "io1"
        case io2 = "io2"
        
        public var supportsIOPS: Bool {
            switch self {
            case .io1, .io2, .gp3: return true
            case .standard, .gp2: return false
            }
        }
        
        public var supportsThroughput: Bool {
            switch self {
            case .gp3: return true
            case .standard, .gp2, .io1, .io2: return false
            }
        }
    }
}

extension AWS.RDS {
    public struct BackupConfiguration: Sendable {
        public let retentionPeriod: Int
        public let window: String
        public let finalSnapshot: Bool

        public init(
            retentionPeriod: Int = 7,
            window: String = "03:00-04:00",
            finalSnapshot: Bool = true
        ) {
            self.retentionPeriod = retentionPeriod
            self.window = window
            self.finalSnapshot = finalSnapshot
        }
    }

    public struct MaintenanceWindow: Sendable {
        public let window: String
        public let autoMinorVersionUpgrade: Bool

        public init(
            window: String = "sun:04:00-sun:05:00",
            autoMinorVersionUpgrade: Bool = false
        ) {
            self.window = window
            self.autoMinorVersionUpgrade = autoMinorVersionUpgrade
        }
    }

    public struct ParameterGroupConfiguration: Sendable {
        public let parameters: [String: any Input<String>]

        public init(parameters: [String: any Input<String>]) {
            self.parameters = parameters
        }
    }
}

extension AWS.RDS {
    public struct ReadReplicaConfiguration: Sendable {
        public let instanceClass: InstanceClass?
        public let publiclyAccessible: Bool?
        public let autoMinorVersionUpgrade: Bool?
        public let performanceInsightsEnabled: Bool?
        public let monitoringInterval: Int?

        public init(
            instanceClass: InstanceClass? = nil,
            publiclyAccessible: Bool? = nil,
            autoMinorVersionUpgrade: Bool? = nil,
            performanceInsightsEnabled: Bool? = nil,
            monitoringInterval: Int? = nil
        ) {
            self.instanceClass = instanceClass
            self.publiclyAccessible = publiclyAccessible
            self.autoMinorVersionUpgrade = autoMinorVersionUpgrade
            self.performanceInsightsEnabled = performanceInsightsEnabled
            self.monitoringInterval = monitoringInterval
        }
    }
}

extension AWS.RDS: Linkable {
    public var actions: [String] {
        [
            "rds-db:connect"
        ]
    }

    public var resources: [Output<String>] {
        ["\(instance.arn)/\(masterUsername)"]
    }

    public var properties: LinkProperties? {
        return .init(
            type: "rds",
            name: instance.chosenName,
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
