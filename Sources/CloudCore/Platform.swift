public enum Platform: Sendable, CaseIterable {
    case linux
    case macOS
}

extension Platform {
    public static var current: Platform {
        #if os(Linux)
            return .linux
        #elseif os(macOS)
            return .macOS
        #else
            fatalError("Unsupported platform")
        #endif
    }
}

extension Platform {
    public var pulumiPlatform: String {
        switch self {
        case .linux:
            return "linux"
        case .macOS:
            return "darwin"
        }
    }

    public var binaryenPlatform: String {
        switch self {
        case .linux:
            return "linux"
        case .macOS:
            return "macos"
        }
    }
}
