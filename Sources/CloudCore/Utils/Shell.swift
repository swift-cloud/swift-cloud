import Foundation
import Subprocess

public enum ShellError: Error, Sendable {
    case terminated(errorCode: Int32, stderr: String)
}

public enum ShellEvent: Sendable {
    case stdout(_: String)
    case stderr(_: String)
    
    func string() -> String? {
        switch self {
        case .stderr(let text):
            return text
        case .stdout(let text):
            return text
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

@discardableResult
public func shellOut(
    to command: Executable,
    arguments: [String],
    workingDirectory: String? = nil,
    environment: [String: String] = Files.currentEnvironment(),
    onEvent: ShellEventHandler? = nil
) async throws -> (stdout: String, stderr: String) {
    let buffer = ShellOutputBuffer()
    
    let result = try await run(
        command,
        arguments: .init(arguments),
        environment: .inherit,
        workingDirectory: nil
    ) { execution, input, out, err in
        await withThrowingTaskGroup(of: Void.self) { group in
            group.addTask {
                for try await line in out.lines() {
                    await buffer.appendStdout(line)
                    onEvent?(ShellEvent.stdout(line))
                }
            }
            group.addTask {
                for try await line in err.lines() {
                    await buffer.appendStderr(line)
                    onEvent?(ShellEvent.stderr(line))
                }
            }
        }
    }
    
    switch result.terminationStatus {
    case .exited(let code) where code > 0:
        throw ShellError.terminated(errorCode: code, stderr: await buffer.stderr)
    case .unhandledException(let code):
        throw ShellError.terminated(errorCode: code, stderr: await buffer.stderr)
    default:
        break
    }

    return await (buffer.stdout, buffer.stderr)
}

public func shellStream(
    to command: Executable,
    arguments: [String],
    workingDirectory: String? = nil,
    environment: [String: String] = ProcessInfo.processInfo.environment
) throws -> AsyncThrowingStream<ShellEvent, any Error> {
    return AsyncThrowingStream<ShellEvent, Error>(ShellEvent.self) { continuation in
        Task.detached {
            try? await shellOut(
                to: command,
                arguments: arguments,
                workingDirectory: workingDirectory,
                environment: environment
            ) {
                continuation.yield($0)
            }
        }
    }
}
