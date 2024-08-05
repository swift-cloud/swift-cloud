import Foundation

extension String {
    func compactJSON() -> String {
        guard let data = self.data(using: .utf8) else {
            fatalError("Failed to convert string to data")
        }
        guard let doc = try? JSONSerialization.jsonObject(with: data) else {
            fatalError("Failed to convert data to JSON")
        }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: doc) else {
            fatalError("Failed to convert JSON to data")
        }
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            fatalError("Failed to convert data to string")
        }
        return jsonString
    }
}
