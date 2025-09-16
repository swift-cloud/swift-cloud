import AsyncHTTPClient
import Foundation

// https://www.pulumi.com/docs/iac/download-install/versions/
public let PulumiClientVersion = "v3.188.0"

extension Pulumi {
    public struct Client: Sendable {
        public enum SetupError: Error {
            case downloadFailed
            case extractionFailed
        }

        public let context: String

        public let version: String

        private let passphrase: String

        public var isSetup: Bool {
            Files.fileExists(atPath: executablePath)
        }

        public init(
            context: String,
            version: String = PulumiClientVersion,
            passphrase: String = "passphrase"
        ) {
            self.context = context
            self.version = version
            self.passphrase = passphrase
        }
    }
}

extension Pulumi.Client {
    private var statePath: String {
        "\(Context.cloudDirectory)"
    }

    private var workingDirectory: String {
        "\(Context.cloudDirectory)/\(context)"
    }

    private var configFilePath: String {
        "\(workingDirectory)/Pulumi.yaml"
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
        let spinner = UI.spinner(label: "Installing Swift Cloud")
        defer { spinner.stop() }

        let arch = Architecture.current.pulumiArchitecture
        let platform = Platform.current.pulumiPlatform
        let url = "https://get.pulumi.com/releases/sdk/pulumi-\(version)-\(platform)-\(arch).tar.gz"

        // Create cli directory if it doesn't exist
        try Files.createDirectory(atPath: pulumiPath)

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

        try Files.createFile(atPath: downloadPath, contents: data)

        // Extract the archive
        try await shellOut(
            to: .path("/usr/bin/tar"),
            arguments: ["-xzf", downloadPath, "-C", pulumiPath, "--strip-components=1"]
        )

        // Clean up the downloaded archive
        try Files.removeFile(atPath: downloadPath)

        // Verify that the Pulumi CLI was successfully installed
        guard Files.fileExists(atPath: executablePath) else {
            throw SetupError.extractionFailed
        }
    }
}

extension Pulumi.Client {
    @discardableResult
    public func invoke(
        command: String,
        arguments: [String] = [],
        onEvent: ShellEventHandler? = nil
    ) async throws -> String {
        if !isSetup {
            try await setup()
        }

        var environment = Files.currentEnvironment()
        environment["PATH"] = "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
        environment["PULUMI_CONFIG_PASSPHRASE"] = self.passphrase
        environment["PULUMI_SKIP_UPDATE_CHECK"] = "true"
        environment["PULUMI_EXPERIMENTAL"] = "true"
        environment["PULUMI_SKIP_CONFIRMATIONS"] = "true"

        let (stdout, _) = try await shellOut(
            to: .path(.init(executablePath)),
            arguments: [command] + arguments + ["--non-interactive"],
            workingDirectory: workingDirectory,
            environment: environment,
            onEvent: onEvent
        )

        return stdout
    }
}

extension Pulumi.Client {
    public func stack() async throws -> Pulumi.Stack {
        let output = try await invoke(command: "stack", arguments: ["export"])
        let decoder = JSONDecoder()
        decoder.configureISO8601DateDecoding()
        return try decoder.decode(Pulumi.Stack.self, from: .init(output.utf8))
    }

    public func stackOutputs() async throws -> [String: AnyCodable] {
        return try await stack().stackResource()?.outputs ?? [:]
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
            if let value, !value.isEmpty {
                let secret =
                    configKey.lowercased().contains("secret")
                    || configKey.lowercased().contains("password")
                    || configKey.lowercased().contains("token")
                try await invoke(
                    command: "config", arguments: ["set", configKey, value, secret ? "--secret" : "--plaintext"])
            } else {
                try await invoke(command: "config", arguments: ["rm", configKey])
            }
        }
    }
}

extension Pulumi.Client {
    public func writePulumiProject(_ project: Pulumi.Project) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        encoder.keyEncodingStrategy = .useDefaultKeys
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(project)
        try Files.createFile(atPath: configFilePath, contents: data)
    }
}

extension Pulumi.Client {
    public func upsertStack(stage: String) async throws {
        try Files.createDirectory(atPath: statePath)
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
