import ConsoleKitTerminal
import Foundation

public final class Context: Sendable {
    public let stage: String
    public let project: any Project
    public let package: Package
    public let store: Store
    public let builder: Builder
    public let home: HomeProvider
    public let startDate = Date()

    public var packageName: String {
        tokenize(package.name)
    }

    public var isProduction: Bool {
        stage == "production" || stage == "prod"
    }

    init(stage: String, project: any Project, package: Package, store: Store, builder: Builder) {
        self.stage = tokenize(stage)
        self.project = project
        self.package = package
        self.store = store
        self.builder = builder
        self.home = project.home
    }
}

extension Context {
    @TaskLocal public static var current: Context!
}

extension Context {
    public static let projectDirectory = currentDirectoryPath()

    public static let buildDirectory = "\(projectDirectory)/.build"

    public static let cloudDirectory = "\(projectDirectory)/.cloud"

    public static let cloudAssetsDirectory = "\(cloudDirectory)/assets"

    public static let cloudBinDirectory = "\(cloudDirectory)/bin"

    public static let userCloudDirectory = "\(userHomeDirectoryPath())/.cloud"

    public static let cloudKitResourcesDirectory = "\(buildDirectory)/checkouts/swift-cloud/Sources/CloudKit/_Resources"

    public static let environment = currentEnvironment()
}

extension Context {
    public struct Package: Sendable, Codable {
        public let name: String
    }
}

extension Context.Package {
    public static func current() async throws -> Self {
        let (output, _) = try await shellOut(to: "swift", arguments: ["package", "dump-package"])
        let data = Data(output.utf8)
        return try JSONDecoder().decode(Self.self, from: data)
    }
}
