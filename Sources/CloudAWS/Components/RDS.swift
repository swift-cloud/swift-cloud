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
            engineLifecycleSupport: EngineLifecycleSupport = .disabled,
            vpc: VPC.Configuration,
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            // Validate that backup and maintenance windows don't overlap
            Self.validateWindowsDoNotOverlap(backup: backupConfiguration.window, maintenance: maintenanceWindow.schedule)
            
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
                    "backupWindow": backupConfiguration.window.stringValue,
                    "maintenanceWindow": maintenanceWindow.schedule.stringValue,
                    "autoMinorVersionUpgrade": maintenanceWindow.autoMinorVersionUpgrade,
                    "performanceInsightsEnabled": performanceInsightsEnabled,
                    "monitoringInterval": monitoringInterval,
                    "deletionProtection": deletionProtection,
                    "skipFinalSnapshot": !backupConfiguration.finalSnapshot,
                    "finalSnapshotIdentifier": backupConfiguration.finalSnapshot
                        ? tokenize(context.stage, name, "final") : nil,
                    "applyImmediately": true,
                    "engineLifecycleSupport": engine.supportsEngineLifecycleSupport ? engineLifecycleSupport.rawValue : nil,
                    "tags": ["Name": instanceIdentifier],
                ],
                options: options,
                context: context,
                dependsOn: [subnetGroup, parameterGroupResource, optionGroup].compactMap { $0 }
            )

        }
        
        private static func validateWindowsDoNotOverlap(backup: BackupWindow, maintenance: MaintenanceSchedule) {
            let backupStart = backup.startMinutes
            let backupEnd = backup.endMinutes
            let maintenanceStart = maintenance.startMinutes
            let maintenanceEnd = maintenance.endMinutes
            
            // Check if backup window overlaps with maintenance window
            // Two ranges overlap if: !(range1.end <= range2.start || range2.end <= range1.start)
            let overlaps = !(backupEnd <= maintenanceStart || maintenanceEnd <= backupStart)
            
            if overlaps {
                fatalError("Backup window '\(backup.stringValue)' overlaps with maintenance window '\(maintenance.stringValue)'. Windows must not overlap.")
            }
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
        
        public var supportsEngineLifecycleSupport: Bool {
            switch self {
            case .postgres, .mysql: return true
            case .mariadb, .oracle, .sqlserver: return false
            }
        }
    }

    public enum PostgresVersion: String, Sendable {
        case v17_2 = "17.2"
        case v16_6 = "16.6"
        case v16_4 = "16.4"
        case v15_8 = "15.8"
        case v14_13 = "14.13"
        case v13_16 = "13.16"

        public var majorVersion: String {
            switch self {
            case .v17_2: return "17"
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
    public enum Timezone: String, Sendable, CaseIterable {
        case utc = "UTC"
        case est = "EST"  // UTC-5
        case cst = "CST"  // UTC-6  
        case mst = "MST"  // UTC-7
        case pst = "PST"  // UTC-8
        case gmt = "GMT"  // UTC+0
        case cet = "CET"  // UTC+1
        case jst = "JST"  // UTC+9
        case ist = "IST"  // UTC+5:30
        
        internal var utcOffset: Int {
            switch self {
            case .utc, .gmt: return 0
            case .est: return 5   // EST is UTC-5, so to convert to UTC we add 5
            case .cst: return 6   // CST is UTC-6, so to convert to UTC we add 6
            case .mst: return 7   // MST is UTC-7, so to convert to UTC we add 7
            case .pst: return 8   // PST is UTC-8, so to convert to UTC we add 8
            case .cet: return -1  // CET is UTC+1, so to convert to UTC we subtract 1
            case .jst: return -9  // JST is UTC+9, so to convert to UTC we subtract 9
            case .ist: return -5  // IST is UTC+5:30, so to convert to UTC we subtract 5:30
            }
        }
        
        internal var minuteOffset: Int {
            switch self {
            case .ist: return -30 // IST is UTC+5:30, so subtract 30 minutes to convert to UTC
            default: return 0
            }
        }
    }
    
    public struct Time: Sendable {
        public let hour: Int    // 0-23
        public let minute: Int  // 0, 15, 30, 45 (rounded to nearest 15-minute interval)
        
        public init(_ hour: Int, _ minute: Int = 0) {
            // Clamp values to valid ranges instead of crashing
            self.hour = max(0, min(23, hour))
            // Round to nearest 15-minute interval (AWS requirement for backup/maintenance windows)
            self.minute = [0, 15, 30, 45].min(by: { abs($0 - minute) < abs($1 - minute) }) ?? 0
        }
        
        // Convert local time to UTC based on timezone
        internal func toUTC(from timezone: Timezone) -> Time {
            let offsetMinutes = timezone.utcOffset * 60 + timezone.minuteOffset
            let totalMinutes = (hour * 60 + minute) + offsetMinutes
            // Ensure we get a positive result in 0-1439 range (24 * 60 - 1)
            let utcMinutes = ((totalMinutes % (24 * 60)) + (24 * 60)) % (24 * 60)
            return Time(utcMinutes / 60, utcMinutes % 60)
        }
        
        internal var stringValue: String {
            let hourStr = hour < 10 ? "0\(hour)" : "\(hour)"
            let minuteStr = minute < 10 ? "0\(minute)" : "\(minute)"
            return "\(hourStr):\(minuteStr)"
        }
        
        internal var totalMinutes: Int {
            return hour * 60 + minute
        }
    }
    
    public struct BackupWindow: Sendable {
        private let startTime: Time
        private let durationHours: Int
        private let timezone: Timezone
        
        public enum Duration: Int, Sendable, CaseIterable {
            case thirtyMinutes = 0
            case oneHour = 1, twoHours = 2, threeHours = 3, fourHours = 4
            case fiveHours = 5, sixHours = 6, sevenHours = 7, eightHours = 8
            
            internal var minutes: Int {
                return rawValue == 0 ? 30 : rawValue * 60
            }
        }
        
        public init(at time: Time, for duration: Duration, in timezone: Timezone = .utc) {
            self.startTime = time
            self.durationHours = duration.rawValue
            self.timezone = timezone
        }
        
        public init(at hour: Int, for duration: Duration, in timezone: Timezone = .utc) {
            self.init(at: Time(hour), for: duration, in: timezone)
        }
        
        public init(at hour: Int, _ minute: Int = 0, for durationHours: Int, in timezone: Timezone = .utc) {
            // Clamp duration to valid AWS range
            let clampedDuration = max(0, min(8, durationHours))
            self.startTime = Time(hour, minute)
            self.durationHours = clampedDuration
            self.timezone = timezone
        }
        
        internal var stringValue: String {
            let utcStart = startTime.toUTC(from: timezone)
            let endMinutes = utcStart.totalMinutes + (durationHours == 0 ? 30 : durationHours * 60)
            let utcEndMinutes = endMinutes % (24 * 60)
            let utcEnd = Time(utcEndMinutes / 60, utcEndMinutes % 60)
            return "\(utcStart.stringValue)-\(utcEnd.stringValue)"
        }
        
        internal var startMinutes: Int {
            return startTime.toUTC(from: timezone).totalMinutes
        }
        
        internal var endMinutes: Int {
            let duration = durationHours == 0 ? 30 : durationHours * 60
            return (startTime.toUTC(from: timezone).totalMinutes + duration) % (24 * 60)
        }
        
        // Common backup windows - easy to understand
        public static let earlyMorning = BackupWindow(at: 3, for: .oneHour)      // 3 AM UTC, 1 hour
        public static let lateMorning = BackupWindow(at: 9, for: .oneHour)       // 9 AM UTC, 1 hour
        public static let lateNight = BackupWindow(at: 23, for: .oneHour)        // 11 PM UTC, 1 hour
        public static let quickBackup = BackupWindow(at: 2, for: .thirtyMinutes) // 2 AM UTC, 30 minutes
        public static let longBackup = BackupWindow(at: 1, for: .eightHours)     // 1 AM UTC, 8 hours
    }

    public struct BackupConfiguration: Sendable {
        public let retentionPeriod: Int
        public let window: BackupWindow
        public let finalSnapshot: Bool

        public init(
            retentionPeriod: Int = 7,
            window: BackupWindow = .earlyMorning,
            finalSnapshot: Bool = true
        ) {
            self.retentionPeriod = retentionPeriod
            self.window = window
            self.finalSnapshot = finalSnapshot
        }
    }

    public struct MaintenanceSchedule: Sendable {
        private let weekday: Weekday
        private let time: Time
        private let timezone: Timezone
        
        // Maintenance windows are always 30 minutes (AWS requirement)
        public init(on weekday: Weekday, at time: Time, in timezone: Timezone = .utc) {
            self.weekday = weekday
            self.time = time
            self.timezone = timezone
        }
        
        public init(on weekday: Weekday, at hour: Int, _ minute: Int = 0, in timezone: Timezone = .utc) {
            self.weekday = weekday
            self.time = Time(hour, minute)
            self.timezone = timezone
        }
        
        public enum Weekday: Int, Sendable, CaseIterable {
            case sunday = 0, monday = 1, tuesday = 2, wednesday = 3
            case thursday = 4, friday = 5, saturday = 6
            
            internal var shortName: String {
                switch self {
                case .sunday: return "sun"
                case .monday: return "mon"
                case .tuesday: return "tue"
                case .wednesday: return "wed"
                case .thursday: return "thu"
                case .friday: return "fri"
                case .saturday: return "sat"
                }
            }
        }
        
        internal var stringValue: String {
            let utcTime = time.toUTC(from: timezone)
            let endMinutes = (utcTime.totalMinutes + 30) % (24 * 60) // Always 30 minutes
            let endTime = Time(endMinutes / 60, endMinutes % 60)
            
            // Handle day rollover for maintenance window
            // We need to check if the original local time + conversion causes day change
            let originalMinutes = time.hour * 60 + time.minute
            let offsetMinutes = timezone.utcOffset * 60 + timezone.minuteOffset
            let utcTotalMinutes = originalMinutes + offsetMinutes
            
            var startWeekday = weekday
            var endWeekday = weekday
            
            // Adjust start day if UTC conversion caused day rollover
            if utcTotalMinutes < 0 {
                startWeekday = Weekday(rawValue: (weekday.rawValue + 6) % 7) ?? .saturday // Previous day
            } else if utcTotalMinutes >= 24 * 60 {
                startWeekday = Weekday(rawValue: (weekday.rawValue + 1) % 7) ?? .sunday // Next day
            }
            
            // Adjust end day if maintenance window crosses midnight
            if utcTime.totalMinutes + 30 >= 24 * 60 {
                endWeekday = Weekday(rawValue: (startWeekday.rawValue + 1) % 7) ?? .sunday
            } else {
                endWeekday = startWeekday
            }
            
            return "\(startWeekday.shortName):\(utcTime.stringValue)-\(endWeekday.shortName):\(endTime.stringValue)"
        }
        
        internal var startMinutes: Int {
            return (weekday.rawValue * 24 * 60) + time.toUTC(from: timezone).totalMinutes
        }
        
        internal var endMinutes: Int {
            let utcTime = time.toUTC(from: timezone)
            let endMinutes = (utcTime.totalMinutes + 30) % (24 * 60)
            var endDay = weekday.rawValue
            if utcTime.totalMinutes + 30 >= 24 * 60 {
                endDay = (weekday.rawValue + 1) % 7
            }
            return (endDay * 24 * 60) + endMinutes
        }
        
        // Common maintenance windows
        public static let sundayEarlyMorning = MaintenanceSchedule(on: .sunday, at: 4)      // 4 AM UTC
        public static let sundayLateNight = MaintenanceSchedule(on: .sunday, at: 23)        // 11 PM UTC
        public static let mondayMorning = MaintenanceSchedule(on: .monday, at: 6)           // 6 AM UTC
        public static let tuesdayNight = MaintenanceSchedule(on: .tuesday, at: 22)          // 10 PM UTC
        public static let saturdayMidnight = MaintenanceSchedule(on: .saturday, at: 23, 30) // 11:30 PM UTC
    }

    public struct MaintenanceWindow: Sendable {
        public let schedule: MaintenanceSchedule
        public let autoMinorVersionUpgrade: Bool

        public init(
            schedule: MaintenanceSchedule = .sundayEarlyMorning,
            autoMinorVersionUpgrade: Bool = false
        ) {
            self.schedule = schedule
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
    public enum EngineLifecycleSupport: String, Sendable {
        case enabled = "open-source-rds-extended-support"
        case disabled = "open-source-rds-extended-support-disabled"
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
