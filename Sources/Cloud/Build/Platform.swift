public enum Platform: Sendable, CaseIterable {
    case linux
    case macOS
    case windows
}

extension Platform {
    public static var current: Platform {
        #if os(Linux)
            return .linux
        #elseif os(macOS)
            return .macOS
        #elseif os(Windows)
            return .windows
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
        case .windows:
            return "windows"
        }
    }
}
