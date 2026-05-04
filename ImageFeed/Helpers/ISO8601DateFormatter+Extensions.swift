import Foundation

extension ISO8601DateFormatter {
    static let appFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
}
