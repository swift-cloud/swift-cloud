import ConsoleKitTerminal

public enum ui {}

extension ui {
    public static var cli: Terminal {
        Context.current.terminal
    }
}
