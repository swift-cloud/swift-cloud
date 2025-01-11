import CloudCore

public protocol VercelProject: Project {}

extension VercelProject {
    public var providers: [Provider] {
        [.vercel()]
    }
}
