import Cloud

public protocol DigitalOceanProject: Project {}

extension DigitalOceanProject {
    public var home: Home.AWS {
        Home.AWS()
    }

    public var providers: [Provider] {
        [.digitalOcean()]
    }
}
