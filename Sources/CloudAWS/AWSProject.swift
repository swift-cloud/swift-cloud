import CloudCore

public protocol AWSProject: Project {
    var region: String { get }
}

extension AWSProject {
    public var region: String {
        "us-east-1"
    }

    public var home: any HomeProvider {
        .aws(region: region)
    }

    public var providers: [Provider] {
        [.aws(region: region)]
    }
}
