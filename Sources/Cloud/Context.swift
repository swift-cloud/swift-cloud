import Foundation

public final class Context: Sendable {
    public let stage: String

    init(stage: String) {
        self.stage = stage
    }
}

extension Context {
    @TaskLocal public static var current: Context!
}

extension Context {
    public static let cloudDirectory = "\(currentDirectoryPath())/.cloud"
}
