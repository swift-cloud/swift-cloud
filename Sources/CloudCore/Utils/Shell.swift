private import Command
import Foundation
import Subprocess

public enum ShellError: Error, Sendable {
    case terminated(errorCode: Int32, stderr: String)
}

public enum ShellEvent: Sendable {
    case stdout(_: String)
    case stderr(_: String)

    fileprivate init(_ event: CommandEvent) {
        switch event {
        case .standardOutput:
            self = .stdout(event.string() ?? "")
        case .standardError:
            self = .stderr(event.string() ?? "")
        }
    }

    func string() -> String? {
        switch self {
        case .stderr(let text):
            return text
        case .stdout(let text):
            return text
        }
    }
}

public enum ShellExecutable {
    case name(_ value: String)
    case path(_ value: String)

    var value: String {
        switch self {
        case .name(let value):
            return value
        case .path(let value):
            return value
        }
    }
}

public typealias ShellEventHandler = @Sendable (ShellEvent) -> Void

private actor ShellOutputBuffer {
    private(set) var stdout = ""
    private(set) var stderr = ""

    func appendStdout(_ line: String) {
        stdout += line + "\n"
    }

    func appendStderr(_ line: String) {
        stderr += line + "\n"
    }
}

private let shell = CommandRunner()

@discardableResult
public func shellOut(
    to command: ShellExecutable,
    arguments: [String],
    workingDirectory: String? = nil,
    environment: [String: String] = Files.currentEnvironment(),
    onEvent: ShellEventHandler? = nil
) async throws -> (stdout: String, stderr: String) {
    var std = ""
    var stdout = ""
    var stderr = ""
    let stream = try shellStream(
        to: command,
        arguments: arguments,
        workingDirectory: workingDirectory,
        environment: environment
    )
    do {
        for try await line in stream {
            std += line.string() ?? ""
            switch line {
            case .stdout:
                stdout += line.string() ?? ""
            case .stderr:
                stderr += line.string() ?? ""
            }
            onEvent?(line)
        }
        return (stdout, stderr)
    } catch let CommandError.terminated(errorCode, _) {
        throw ShellError.terminated(errorCode: errorCode, stderr: std)
    } catch {
        throw ShellError.terminated(errorCode: 255, stderr: std)
    }
}

public func shellStream(
    to command: ShellExecutable,
    arguments: [String],
    workingDirectory: String? = nil,
    environment: [String: String] = ProcessInfo.processInfo.environment
) throws -> some AsyncSequence<ShellEvent, any Error> {
    return shell.run(
        arguments: [command.value] + arguments,
        environment: environment,
        workingDirectory: try workingDirectory.map { try .init(validating: $0) }
    ).map(ShellEvent.init)
}
