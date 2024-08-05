public enum Architecture {
    case arm64
    case x86
}

extension Architecture {
    public var dockerPlatform: String {
        switch self {
        case .arm64:
            return "arm64"
        case .x86:
            return "x86_64"
        }
    }

    public var lambdaArchitecture: String {
        switch self {
        case .arm64:
            return "arm64"
        case .x86:
            return "x86_64"
        }
    }

    public var swiftBuildLinuxDirectory: String {
        switch self {
        case .arm64:
            return "aarch64-unknown-linux-gnu"
        case .x86:
            return "x86_64-unknown-linux-gnu"
        }
    }
}

extension Architecture {
    public static var current: Architecture {
        #if arch(arm64)
            return .arm64
        #else
            return .x86
        #endif
    }
}
