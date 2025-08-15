import CloudCore

extension AWS.RDS {
    public struct GetEngineVersionFilter {
        public let name: String
        public let values: [String]
    }
    
    public struct GetEngineVersion {
        public let defaultCharacterSet: String
        public let engine: String
        public let engineDescription: String
        public let exportableLogTypes: [String]
        public let id: String
        public let parameterGroupFamily: String
        public let region: String
        public let status: String
        public let supportedCharacterSets: [String]
        public let supportedFeatureNames: [String]
        public let supportedModes: [String]
        public let supportedTimezones: [String]
        public let supportsCertificateRotationWithoutRestart: Bool
        public let supportsGlobalDatabases: Bool
        public let supportsIntegrations: Bool
        public let supportsLimitlessDatabase: Bool
        public let supportsLocalWriteForwarding: Bool
        public let supportsLogExportsToCloudwatch: Bool
        public let supportsParallelQuery: Bool
        public let supportsReadReplica: Bool
        public let validMajorTargets: [String]
        public let validMinorTargets: [String]
        public let validUpgradeTargets: [String]
        public let version: String
        public let versionActual: String
        public let versionDescription: String
        public let defaultOnly: Bool
        public let filters: [GetEngineVersionFilter]
        public let hasMajorTarget: Bool
        public let hasMinorTarget: Bool
        public let includeAll: Bool
        public let latest: Bool
        public let preferredMajorTargets: [String]
        public let preferredUpgradeTargets: [String]
        public let preferredVersions: [String]
    }
    
    public static func getEngineVersion(
        engine: any Input<String>,
        defaultOnly: (any Input<Bool>)? = nil,
        filters: (any Input<[GetEngineVersionFilter]>)? = nil,
        hasMajorTarget: (any Input<Bool>)? = nil,
        hasMinorTarget: (any Input<Bool>)? = nil,
        includeAll: (any Input<Bool>)? = nil,
        latest: (any Input<Bool>)? = nil,
        parameterGroupFamily: (any Input<String>)? = nil,
        preferredMajorTargets: (any Input<[String]>)? = nil,
        preferredUpgradeTargets: (any Input<[String]>)? = nil,
        preferredVersions: (any Input<[String]>)? = nil,
        region: (any Input<String>)? = nil,
        version: (any Input<String>)? = nil
    ) -> Output<GetEngineVersion> {
        var arguments: [String: Any] = ["engine": engine]
        
        if let defaultOnly = defaultOnly { arguments["defaultOnly"] = defaultOnly }
        if let filters = filters { arguments["filters"] = filters }
        if let hasMajorTarget = hasMajorTarget { arguments["hasMajorTarget"] = hasMajorTarget }
        if let hasMinorTarget = hasMinorTarget { arguments["hasMinorTarget"] = hasMinorTarget }
        if let includeAll = includeAll { arguments["includeAll"] = includeAll }
        if let latest = latest { arguments["latest"] = latest }
        if let parameterGroupFamily = parameterGroupFamily { arguments["parameterGroupFamily"] = parameterGroupFamily }
        if let preferredMajorTargets = preferredMajorTargets { arguments["preferredMajorTargets"] = preferredMajorTargets }
        if let preferredUpgradeTargets = preferredUpgradeTargets { arguments["preferredUpgradeTargets"] = preferredUpgradeTargets }
        if let preferredVersions = preferredVersions { arguments["preferredVersions"] = preferredVersions }
        if let region = region { arguments["region"] = region }
        if let version = version { arguments["version"] = version }
        
        let variable = Variable<GetEngineVersion>.invoke(
            name: "\(engine)-engine-version",
            function: "aws:rds:getEngineVersion",
            arguments: arguments
        )
        return variable.output
    }
}