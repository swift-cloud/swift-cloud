import AsyncHTTPClient
import Foundation
import ShellOut

public let PulumiClientVersion = "v3.127.0"

extension Pulumi {
    public struct Client: Sendable {
        public enum SetupError: Error {
            case downloadFailed
            case extractionFailed
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
            let arch = Architecture.current.pulumiArchitecture
            let platform = Platform.current.pulumiPlatform
            let url = "https://get.pulumi.com/releases/sdk/pulumi-\(version)-\(platform)-\(arch).tar.gz"

            // Create .build directory if it doesn't exist
            try FileManager.default.createDirectory(atPath: pulumiPath, withIntermediateDirectories: true)

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

            print("Pulumi CLI extracted successfully")

            // Clean up the downloaded archive
            try FileManager.default.removeItem(atPath: downloadPath)

            // Verify that the Pulumi CLI was successfully installed
            guard FileManager.default.fileExists(atPath: executablePath) else {
                throw SetupError.extractionFailed
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
}
