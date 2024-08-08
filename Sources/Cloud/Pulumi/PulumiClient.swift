import AsyncHTTPClient
import Foundation
import ShellOut
import Yams

public let PulumiClientVersion = "v3.128.0"

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
    private var statePath: String {
        "\(Context.cloudDirectory)"
    }

    private var configFilePath: String {
        "\(Context.cloudDirectory)/Pulumi.yaml"
    }

    private var pulumiPath: String {
        "\(Context.cloudBinDirectory)/pulumi-\(version)"
    }

    private var executablePath: String {
        "\(pulumiPath)/pulumi"
    }
}

extension Pulumi.Client {
    public func setup() async throws {
        let spinner = ui.spinner(label: "Installing Swift Cloud")
        defer { spinner.stop() }

        let arch = Architecture.current.pulumiArchitecture
        let platform = Platform.current.pulumiPlatform
        let url = "https://get.pulumi.com/releases/sdk/pulumi-\(version)-\(platform)-\(arch).tar.gz"

        // Create cli directory if it doesn't exist
        try createDirectory(atPath: pulumiPath)

        // Download Pulumi CLI
        let downloadPath = "\(Context.cloudAssetsDirectory)/pulumi-\(version)-\(platform).tar.gz"

        let httpClient = HTTPClient.shared

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

        // Extract the archive
        if platform == "windows" {
            // Unzip for Windows
            try await shellOut(
                to: "powershell",
                arguments: [
                    "-Command", "Expand-Archive", "-Path", downloadPath, "-DestinationPath", pulumiPath, "-Force",
                ]
            )
        } else {
            // Untar for Linux and macOS
            try await shellOut(
                to: "/usr/bin/tar",
                arguments: ["-xzf", downloadPath, "-C", pulumiPath, "--strip-components=1"]
            )
        }

        // Clean up the downloaded archive
        try removeFile(atPath: downloadPath)

        // Verify that the Pulumi CLI was successfully installed
        guard fileExists(atPath: executablePath) else {
            throw SetupError.extractionFailed
        }
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
    public func installPlugins(_ plugins: [Pulumi.Plugin]) async throws {
        for plugin in plugins {
            try await installPlugin(plugin)
        }
    }

    public func installPlugin(_ plugin: Pulumi.Plugin) async throws {
        try await invoke(
            command: "plugin",
            arguments: ["install", "resource", plugin.name, plugin.version, "--server", plugin.server]
        )
    }
}

extension Pulumi.Client {
    public func configure(_ provider: Provider) async throws {
        for (key, value) in provider.configuration {
            let configKey = "\(provider.name):\(key)"
            if !value.isEmpty {
                try await invoke(command: "config", arguments: ["set", configKey, value])
            } else {
                try await invoke(command: "config", arguments: ["rm", configKey])
            }
        }
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
