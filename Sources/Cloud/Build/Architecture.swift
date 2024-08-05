import Foundation

public enum Architecture {
    case arm64
    case x86
}

extension Architecture {
    public var dockerPlatformString: String {
        switch self {
        case .arm64:
            return "arm64"
        case .x86:
            return "x86_64"
        }
    }

    public var lambdaString: String {
        switch self {
        case .arm64:
            return "arm64"
        case .x86:
            return "x86_64"
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

public func isAmazonLinux() -> Bool {
    guard let data = FileManager.default.contents(atPath: "/etc/system-release") else {
        return false
    }
    return String(data: data, encoding: .utf8)?.hasPrefix("Amazon Linux") ?? false
}
