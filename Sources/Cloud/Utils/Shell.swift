import Command
import Foundation

private let shell = CommandRunner()

enum ShellError: Error {
    case terminated(errorCode: Int32, stderr: String)
}

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
    do {
        for try await line in stream {
            switch line {
            case .standardOutput:
                stdout += line.string() ?? ""
            case .standardError:
                stderr += line.string() ?? ""
            }
        }
        return (stdout, stderr)
    } catch let CommandError.terminated(errorCode, _) {
        throw ShellError.terminated(errorCode: errorCode, stderr: stderr.count > 0 ? stderr : stdout)
    } catch {
        throw ShellError.terminated(errorCode: 255, stderr: stderr.count > 0 ? stderr : stdout)
    }
}
