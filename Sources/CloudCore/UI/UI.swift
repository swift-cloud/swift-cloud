import ConsoleKitTerminal
import Foundation

public enum UI {}

extension UI {
    public static let cli = Terminal()
}

extension UI {
    /// Whether stdout is an interactive terminal. When false (CI, pipes, cron,
    /// unsized PTYs, agent shells) the animated spinner UI is disabled: off a TTY
    /// it would emit raw ANSI frames into logs and, worse, crash when the reported
    /// terminal width is 0 (`prefix(width - 10)` traps on a negative length).
    public static let isInteractive: Bool = isatty(fileno(stdout)) != 0
}
