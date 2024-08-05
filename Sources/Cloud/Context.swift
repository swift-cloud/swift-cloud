public struct Context {
    @TaskLocal public static var current: Context!

    public internal(set) var stage: String
}
