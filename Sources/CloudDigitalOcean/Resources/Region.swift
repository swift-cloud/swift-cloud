extension DigitalOcean {
    public enum Region: String {
        case nyc1
        case nyc2
        case nyc3
        case ams3
        case sfo2
        case sfo3
        case sgp1
        case lon1
        case fra1
        case tor1
        case blr1
        case syd1

        var description: String {
            switch self {
            case .nyc1, .nyc2, .nyc3:
                return "New York City, United States"
            case .ams3:
                return "Amsterdam, the Netherlands"
            case .sfo2, .sfo3:
                return "San Francisco, United States"
            case .sgp1:
                return "Singapore"
            case .lon1:
                return "London, United Kingdom"
            case .fra1:
                return "Frankfurt, Germany"
            case .tor1:
                return "Toronto, Canada"
            case .blr1:
                return "Bangalore, India"
            case .syd1:
                return "Sydney, Australia"
            }
        }
    }
}
