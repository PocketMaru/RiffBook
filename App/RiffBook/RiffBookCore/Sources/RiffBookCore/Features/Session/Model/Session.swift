import Foundation
import SQLiteData

@Selection
struct Session: Decodable, Identifiable {
    let id: UUID
    var name: String
    var creationDate: Date
    
    struct Create: Encodable {
        var name: String
    }
    
    struct Update: Encodable {
        let id: UUID
        var name: String
        
        init(session: Session) {
            id = session.id
            name = session.name
        }
    }
}
