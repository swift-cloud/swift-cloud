import Foundation

extension JSONDecoder {
    func configureISO8601DateDecoding() {
        self.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            guard let date = Self.parseISO8601Date(dateString) else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format")
            }
            return date
        }
    }

    private static func parseISO8601Date(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter.date(from: dateString)
    }
}
