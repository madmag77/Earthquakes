import Foundation

extension DateFormatter {
    static let earthquakeDisplayDataFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        return df
    }()
}
