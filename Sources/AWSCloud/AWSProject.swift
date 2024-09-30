import Cloud

public protocol AWSProject: Project {}

extension AWSProject {
    public var home: Home.AWS {
        Home.AWS()
    }

    public var providers: [Provider] {
        [.aws()]
    }
}
