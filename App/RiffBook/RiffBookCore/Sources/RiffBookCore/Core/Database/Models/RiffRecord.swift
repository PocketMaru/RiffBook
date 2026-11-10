import Foundation
import SQLiteData

@Table
struct RiffRecord: Identifiable {
    let id: UUID
    var name: String
    var instrument: String
    var key: String
    var tuning: String
    var description: String
    var favorite: Recording.ID?
    var updatedAt: Date
    let createdAt: Date
}

extension RiffRecord {
    init(_ model: Riff) {
        self.id = model.id
        self.name = model.name
        self.instrument = model.instrument
        self.key = model.key
        self.tuning = model.tuning
        self.description = model.description
        self.favorite = model.favorite
        self.updatedAt = model.updatedAt
        self.createdAt = model.createdAt
    }
}
