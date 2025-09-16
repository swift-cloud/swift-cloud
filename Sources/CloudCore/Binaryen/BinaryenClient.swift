import AsyncHTTPClient
import Foundation

// https://github.com/WebAssembly/binaryen/releases
public let BinaryenVersion = "121"

extension Binaryen {
    public struct Client: Sendable {
        public enum SetupError: Error {
            case downloadFailed
            case extractionFailed
        }

        public let version: String

        public var isSetup: Bool {
            Files.fileExists(atPath: executablePath)
        }

        public init(version: String = BinaryenVersion) {
            self.version = version
        }
    }
}

extension Binaryen.Client {
    private var binaryenPath: String {
        "\(Context.cloudBinDirectory)/binaryen-\(version)"
    }

    private var executablePath: String {
        "\(binaryenPath)/bin/wasm-opt"
    }
}

extension Binaryen.Client {
    public func setup() async throws {
        let spinner = UI.spinner(label: "Installing Swift Cloud")
        defer { spinner.stop() }

        let arch = Architecture.current.binaryenArchitecture
        let platform = Platform.current.binaryenPlatform
        let url =
            "https://github.com/WebAssembly/binaryen/releases/download/version_\(version)/binaryen-version_\(version)-\(arch)-\(platform).tar.gz"

        // Create cli directory if it doesn't exist
        try Files.createDirectory(atPath: binaryenPath)

        // Download Binaryen CLI
        let downloadPath = "\(Context.cloudAssetsDirectory)/binaryen-\(version)-\(platform).tar.gz"

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
            arguments: ["-xzf", downloadPath, "-C", binaryenPath, "--strip-components=1"]
        )

        // Clean up the downloaded archive
        try Files.removeFile(atPath: downloadPath)

        // Verify that the Binaryen CLI was successfully installed
        guard Files.fileExists(atPath: executablePath) else {
            throw SetupError.extractionFailed
        }
    }
}

extension Binaryen.Client {
    public func optimize(input: String, output: String) async throws {
        if !isSetup {
            try await setup()
        }
        try await shellOut(
            to: .path(.init(executablePath)),
            arguments: ["-Oz", "-ffm", "-o", output, input]
        )
    }
}
