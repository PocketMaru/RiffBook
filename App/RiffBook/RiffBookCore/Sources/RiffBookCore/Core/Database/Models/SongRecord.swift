import Foundation
import SQLiteData

@Table
struct SongRecord: Identifiable {
    let id: UUID
    var name: String
    var tuning: String
    let creationDate: Date
}

extension SongRecord {
    init(_ model: Song) {
        self.id = model.id
        self.name = model.name
        self.tuning = model.tuning
        self.creationDate = model.creationDate
    }
}
