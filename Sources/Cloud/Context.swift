import Foundation

public final class Context: Sendable {
    public let stage: String
    public let project: Project

    init(stage: String, project: Project) {
        self.stage = stage
        self.project = project
    }
}

extension Context {
    @TaskLocal public static var current: Context!
}

extension Context {
    public static let cloudDirectory = "\(currentDirectoryPath())/.cloud"
}
