import AsyncHTTPClient
import Foundation
import ShellOut

public let PulumiClientVersion = "v3.127.0"

public struct PulumiClient: Sendable {
    public enum DownloadError: Error {
        case unsupportedPlatform
        case downloadFailed
        case extractionFailed
    }

    public enum InvokeError: Error {
        case executionFailed(String)
    }

    public let version: String

    private let passphrase: String

    public var basePath: String {
        Context.cloudDirectory
    }

    public var cliPath: String {
        "\(basePath)/cli"
    }

    public var statePath: String {
        "\(basePath)/state"
    }

    public var configFilePath: String {
        "\(basePath)/Pulumi.yaml"
    }

    private var pulumiPath: String {
        "\(cliPath)/pulumi-\(version)"
    }

    private var executablePath: String {
        "\(pulumiPath)/pulumi/pulumi"
    }

    public var isSetup: Bool {
        FileManager.default.fileExists(atPath: executablePath)
    }

    public init(version: String = PulumiClientVersion, passphrase: String = "passphrase") {
        self.version = version
        self.passphrase = passphrase
    }

    public func setup() async throws {
        // Determine the platform and download URL
        let (platform, url): (String, String) = {
            let arch = Architecture.current.pulumiArchitecture
            #if os(Linux)
                return ("linux", "https://get.pulumi.com/releases/sdk/pulumi-\(version)-linux-\(arch).tar.gz")
            #elseif os(macOS)
                return ("darwin", "https://get.pulumi.com/releases/sdk/pulumi-\(version)-darwin-\(arch).tar.gz")
            #elseif os(Windows)
                return ("windows", "https://get.pulumi.com/releases/sdk/pulumi-\(version)-windows-\(arch).zip")
            #else
                fatalError("Unsupported platform")
            #endif
        }()

        let fm = FileManager.default

        // Create .build directory if it doesn't exist
        try fm.createDirectory(atPath: pulumiPath, withIntermediateDirectories: true)

        // Download Pulumi CLI
        let downloadPath = "\(cliPath)/pulumi-\(version)-\(platform).tar.gz"

        let httpClient = HTTPClient.shared

        print("Downloading Pulumi CLI...")

        let request = HTTPClientRequest(url: url)
        let response = try await httpClient.execute(request, timeout: .seconds(120))

        guard response.status == .ok else {
            throw DownloadError.downloadFailed
        }

        guard let contentLength = response.headers["content-length"].first.flatMap(Int.init) else {
            throw DownloadError.downloadFailed
        }

        let body = try await response.body.collect(upTo: contentLength)
        let data = Data(body.readableBytesView)

        guard fm.createFile(atPath: downloadPath, contents: data) else {
            throw DownloadError.downloadFailed
        }

        print("Pulumi CLI downloaded successfully")

        // Extract the archive
        if platform == "windows" {
            // Unzip for Windows
            try await shellOut(to: "/usr/bin/unzip", arguments: ["-o", downloadPath, "-d", pulumiPath])
        } else {
            // Untar for Linux and macOS
            try await shellOut(to: "/usr/bin/tar", arguments: ["-xzf", downloadPath, "-C", pulumiPath])
        }

        print("Pulumi CLI extracted successfully")

        // Clean up the downloaded archive
        try fm.removeItem(atPath: downloadPath)

        // Verify that the Pulumi CLI was successfully installed
        guard fm.fileExists(atPath: executablePath) else {
            throw DownloadError.extractionFailed
        }

        print("Pulumi CLI setup completed successfully")
    }

    public func setupIfNeeded() async throws {
        if !isSetup {
            try await setup()
        }
    }

    @discardableResult
    public func invoke(
        command: String,
        arguments: [String] = []
    ) async throws -> String {
        try await setupIfNeeded()

        var environment = ProcessInfo.processInfo.environment
        environment["PATH"] = "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
        environment["PULUMI_CONFIG_PASSPHRASE"] = self.passphrase
        environment["PULUMI_SKIP_UPDATE_CHECK"] = "true"
        environment["PULUMI_EXPERIMENTAL"] = "true"
        environment["PULUMI_SKIP_CONFIRMATIONS"] = "true"

        let (stdout, _) = try await shellOut(
            to: executablePath,
            arguments: [command] + arguments + ["--non-interactive"],
            at: basePath,
            environment: environment
        )

        return stdout
    }
}
