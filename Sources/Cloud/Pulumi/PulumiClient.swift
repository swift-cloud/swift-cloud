import AsyncHTTPClient
import Foundation
import ShellOut
import Yams

public let PulumiClientVersion = "v3.127.0"

extension Pulumi {
    public struct Client: Sendable {
        public enum SetupError: Error {
            case downloadFailed
            case extractionFailed
        }

        public let version: String

        private let passphrase: String

        public var isSetup: Bool {
            fileExists(atPath: executablePath)
        }

        public init(version: String = PulumiClientVersion, passphrase: String = "passphrase") {
            self.version = version
            self.passphrase = passphrase
        }
    }
}

extension Pulumi.Client {
    private var cliPath: String {
        "\(Context.cloudDirectory)/cli"
    }

    private var statePath: String {
        "\(Context.cloudDirectory)/state"
    }

    private var configFilePath: String {
        "\(Context.cloudDirectory)/Pulumi.yaml"
    }

    private var pulumiPath: String {
        "\(cliPath)/pulumi-\(version)"
    }

    private var executablePath: String {
        "\(pulumiPath)/pulumi/pulumi"
    }
}

extension Pulumi.Client {
    public func setup() async throws {
        let arch = Architecture.current.pulumiArchitecture
        let platform = Platform.current.pulumiPlatform
        let url = "https://get.pulumi.com/releases/sdk/pulumi-\(version)-\(platform)-\(arch).tar.gz"

        // Create cli directory if it doesn't exist
        try createDirectory(atPath: pulumiPath)

        // Download Pulumi CLI
        let downloadPath = "\(cliPath)/pulumi-\(version)-\(platform).tar.gz"

        let httpClient = HTTPClient.shared

        print("Downloading Pulumi CLI...")

        let request = HTTPClientRequest(url: url)
        let response = try await httpClient.execute(request, timeout: .seconds(120))

        guard response.status == .ok else {
            throw SetupError.downloadFailed
        }

        guard let contentLength = response.headers["content-length"].first.flatMap(Int.init) else {
            throw SetupError.downloadFailed
        }

        let body = try await response.body.collect(upTo: contentLength)
        let data = Data(body.readableBytesView)

        try createFile(atPath: downloadPath, contents: data)

        print("Pulumi CLI downloaded successfully")

        // Extract the archive
        if platform == "windows" {
            // Unzip for Windows
            try await shellOut(to: "/usr/bin/unzip", arguments: ["-o", downloadPath, "-d", pulumiPath])
        } else {
            // Untar for Linux and macOS
            try await shellOut(to: "/usr/bin/tar", arguments: ["-xzf", downloadPath, "-C", pulumiPath])
        }

        // Clean up the downloaded archive
        try removeFile(atPath: downloadPath)

        // Verify that the Pulumi CLI was successfully installed
        guard fileExists(atPath: executablePath) else {
            throw SetupError.extractionFailed
        }

        print("Pulumi CLI setup completed successfully")
    }
}

extension Pulumi.Client {
    @discardableResult
    public func invoke(
        command: String,
        arguments: [String] = []
    ) async throws -> String {
        if !isSetup {
            try await setup()
        }

        var environment = ProcessInfo.processInfo.environment
        environment["PATH"] = "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
        environment["PULUMI_CONFIG_PASSPHRASE"] = self.passphrase
        environment["PULUMI_SKIP_UPDATE_CHECK"] = "true"
        environment["PULUMI_EXPERIMENTAL"] = "true"
        environment["PULUMI_SKIP_CONFIRMATIONS"] = "true"

        let (stdout, _) = try await shellOut(
            to: executablePath,
            arguments: [command] + arguments + ["--non-interactive"],
            at: Context.cloudDirectory,
            environment: environment
        )

        return stdout
    }
}

extension Pulumi.Client {
    public func writePulumiProject(_ project: Pulumi.Project) throws {
        let encoder = YAMLEncoder()
        encoder.options.indent = 2
        encoder.options.mappingStyle = .block
        encoder.options.sequenceStyle = .block
        encoder.options.sortKeys = true
        let yaml = try encoder.encode(project)
        try createFile(atPath: configFilePath, contents: yaml)
    }
}

extension Pulumi.Client {
    public func upsertStack(stage: String) async throws {
        try createDirectory(atPath: statePath)
        do {
            try await invoke(command: "stack", arguments: ["select", stage])
        } catch {
            try await invoke(command: "stack", arguments: ["init", "--stack", stage])
        }
    }
}

extension Pulumi.Client {
    public func localProjectBackend() -> Pulumi.Project.Backend {
        .init(url: .local(path: statePath))
    }
}
