import Foundation

public struct Context {
    @TaskLocal public static var current: Context!

    public internal(set) var stage: String
}

extension Context {
    public static let cloudDirectory = "\(FileManager.default.currentDirectoryPath)/.cloud"
}
