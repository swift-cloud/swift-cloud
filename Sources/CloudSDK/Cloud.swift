import Foundation

public enum Cloud {}

extension Cloud {
    public enum Resource {}
}

func env(_ key: String) -> String {
    return ProcessInfo.processInfo.environment[key] ?? ""
}
