import Command
import Foundation

private let shell = CommandRunner()

@discardableResult
func shellOut(
    to command: String,
    arguments: [String],
    workingDirectory: String? = nil,
    environment: [String: String] = ProcessInfo.processInfo.environment
) async throws -> (stdout: String, stderr: String) {
    var stdout = ""
    var stderr = ""
    let stream = shell.run(
        arguments: [command] + arguments,
        environment: environment,
        workingDirectory: try workingDirectory.map { try .init(validating: $0) }
    )
    for try await line in stream {
        switch line {
        case .standardOutput:
            stdout += line.string() ?? ""
        case .standardError:
            stderr += line.string() ?? ""
        }
    }
    return (stdout, stderr)
}
