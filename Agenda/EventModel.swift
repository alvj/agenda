import Foundation

struct Event: Codable {
    let name: String?
    let date: Double?
    
    var parsedDate: Date? {
        guard let date = date else {
            return nil
        }
        
        return Date(timeIntervalSince1970: date / 1000)
    }
    
    var formattedDate: String {
        guard let parsedDate = parsedDate else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium

        return formatter.string(from: parsedDate)
    }
}
