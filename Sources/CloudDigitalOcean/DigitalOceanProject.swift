import CloudCore

public protocol DigitalOceanProject: Project {}

extension DigitalOceanProject {
    public var providers: [Provider] {
        [.digitalocean()]
    }
}
