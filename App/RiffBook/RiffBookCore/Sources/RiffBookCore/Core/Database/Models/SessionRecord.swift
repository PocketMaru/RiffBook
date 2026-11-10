import Foundation
import SQLiteData

@Table
struct SessionRecord: Identifiable {
    let id: UUID
    var name: String
    var creationDate: Date
}

extension SessionRecord {
    init(_ model: Session) {
        self.id = model.id
        self.name = model.name
        self.creationDate = model.creationDate
    }
}
