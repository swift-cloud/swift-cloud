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

    public var name: String {
        guard !project.name.isEmpty else {
            return tokenize(package.name)
        }
        return tokenize(project.name)
    }

    public var isProduction: Bool {
        stage == "production" || stage == "prod" || stage == "main" || stage == "master"
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
    public static let projectDirectory = Files.currentDirectoryPath()

    public static let buildDirectory = "\(projectDirectory)/.build"

    public static let cloudDirectory = "\(projectDirectory)/.cloud"

    public static let cloudAssetsDirectory = "\(cloudDirectory)/assets"

    public static let cloudBinDirectory = "\(cloudDirectory)/bin"

    public static let userCloudDirectory = "\(Files.userHomeDirectoryPath())/.cloud"

    public static let cloudSDKResourcesDirectory = "\(buildDirectory)/checkouts/swift-cloud/Sources/CloudSDK/_Resources"

    public static let environment = Files.currentEnvironment()
}

extension Context {
    public struct Package: Sendable, Codable {
        public let name: String
    }
}

extension Context.Package {
    public static func current() async throws -> Self {
        let (output, _) = try await shellOut(to: .name("swift"), arguments: ["package", "dump-package"])
        let data = Data(output.utf8)
        return try JSONDecoder().decode(Self.self, from: data)
    }
}
