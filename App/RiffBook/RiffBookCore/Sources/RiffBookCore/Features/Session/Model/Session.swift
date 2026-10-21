import Foundation
import SQLiteData

@Selection
struct Session: Decodable, Identifiable {
    let id: UUID
    var name: String
    
    @Column(as: [Recording.ID].JSONRepresentation.self)
    var recordings: [Recording.ID]
    
    var creationDate: Date
    
    struct Create: Encodable {
        var name: String
        var recordings: [Recording.ID] = []
    }
    
    struct Update: Encodable {
        let id: UUID
        var name: String
        var recordings: [Recording.ID]
        
        init(session: Session) {
            id = session.id
            name = session.name
            recordings = session.recordings
        }
    }
}
