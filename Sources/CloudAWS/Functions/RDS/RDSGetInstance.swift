import CloudCore

extension AWS {
    public enum RDS {
        public struct GetInstanceMasterUserSecret {
            public let kmsKeyId: String
            public let secretArn: String
            public let secretStatus: String
        }
        
        public struct GetInstance {
            public let address: String
            public let allocatedStorage: Int
            public let autoMinorVersionUpgrade: Bool
            public let availabilityZone: String
            public let backupRetentionPeriod: Int
            public let caCertIdentifier: String
            public let dbInstanceArn: String
            public let dbInstanceClass: String
            public let dbInstanceIdentifier: String
            public let dbName: String
            public let dbSubnetGroup: String
            public let endpoint: String
            public let engine: String
            public let engineVersion: String
            public let hostedZoneId: String
            public let id: String
            public let masterUsername: String
            public let masterUserSecrets: [GetInstanceMasterUserSecret]
            public let multiAz: Bool
            public let port: Int
            public let storageEncrypted: Bool
            public let storageType: String
            public let tags: [String: String]
            public let vpcSecurityGroups: [String]
        }

        public static func getInstance(dbInstanceIdentifier: any Input<String>) -> Output<GetInstance> {
            let variable = Variable<GetInstance>.invoke(
                name: "\(dbInstanceIdentifier)-rds-instance",
                function: "aws:rds:getInstance",
                arguments: ["dbInstanceIdentifier": dbInstanceIdentifier]
            )
            return variable.output
        }

        public static func getInstance(
            dbInstanceIdentifier: any Input<String>,
            tags: any Input<[String: String]>
        ) -> Output<GetInstance> {
            let variable = Variable<GetInstance>.invoke(
                name: "\(dbInstanceIdentifier)-rds-instance",
                function: "aws:rds:getInstance",
                arguments: [
                    "dbInstanceIdentifier": dbInstanceIdentifier,
                    "tags": tags
                ]
            )
            return variable.output
        }
    }
}

extension AWS.RDS.GetInstance: Linkable {
    public var name: String {
        self.dbInstanceIdentifier
    }

    public var actions: [String] {
        [
            "rds-db:connect"
        ]
    }

    public var resources: [String] {
        ["\(self.dbInstanceArn)/\(self.masterUsername)"]
    }

    public var masterPasswordSecret: AWS.RDS.GetInstanceMasterUserSecret {
        self.masterUserSecrets[0]
    }
    
    public var url: String {
        let scheme: String
        switch engine.lowercased() {
        case let e where e.contains("postgres"):
            scheme = "postgres"
        case let e where e.contains("mysql"):
            scheme = "mysql"
        case let e where e.contains("mariadb"):
            scheme = "mysql"
        case let e where e.contains("aurora-postgresql"):
            scheme = "postgres"
        case let e where e.contains("aurora-mysql"):
            scheme = "mysql"
        case let e where e.contains("oracle"):
            scheme = "oracle"
        case let e where e.contains("sqlserver"):
            scheme = "sqlserver"
        default:
            scheme = "unknown"
        }
        return "\(scheme)://\(masterUsername)@\(endpoint):\(port)/\(dbName)"
    }

    public var properties: LinkProperties? {
        return .init(
            type: "rds-instance",
            name: self.dbInstanceIdentifier,
            properties: [
                "hostname": self.endpoint,
                "port": "\(self.port)",
                "databaseName": self.dbName,
                "username": self.masterUsername,
                 "url": url
            ]
        )
    }
}