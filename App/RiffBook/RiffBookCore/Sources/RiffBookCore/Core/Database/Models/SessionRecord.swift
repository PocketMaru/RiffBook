import Foundation
import SQLiteData

@Table
struct SessionRecord: Identifiable {
    let id: UUID
    var name: String
    
    @Column(as: [Recording.ID].JSONRepresentation.self)
    var recordings: [Recording.ID]
    
    var creationDate: Date
    
    init(_ model: Session) {
        self.id = model.id
        self.name = model.name
        self.recordings = model.recordings
        self.creationDate = model.creationDate
    }
}
