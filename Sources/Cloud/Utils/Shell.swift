import Command
import Foundation

private let shell = CommandRunner()

@discardableResult
func shellOut(
    to command: String,
    arguments: [String],
    at path: String? = nil,
    environment: [String: String] = ProcessInfo.processInfo.environment
) async throws -> (String, String) {
    var stdout = ""
    var stderr = ""
    let stream = shell.run(
        arguments: [command] + arguments,
        environment: environment,
        workingDirectory: try path.map { try .init(validating: $0) }
    )
    for try await line in stream {
        switch line {
        case .standardOutput:
            stdout += line.utf8String
        case .standardError:
            stderr += line.utf8String
        }
    }
    return (stdout, stderr)
}
