import ConsoleKitTerminal
import Foundation

public final class Context: Sendable {
    public let stage: String
    public let project: Project
    public let store: Store
    public let builder: Builder
    public let startDate = Date()

    init(stage: String, project: Project, store: Store, builder: Builder) {
        self.stage = stage
        self.project = project
        self.store = store
        self.builder = builder
    }
}

extension Context {
    @TaskLocal public static var current: Context!
}

extension Context {
    public static let cloudDirectory = "\(currentDirectoryPath())/.cloud"

    public static let cloudAssetsDirectory = "\(cloudDirectory)/assets"

    public static let cloudBinDirectory = "\(cloudDirectory)/bin"

    public static let userCloudDirectory = "\(userHomeDirectoryPath())/.cloud"
}
