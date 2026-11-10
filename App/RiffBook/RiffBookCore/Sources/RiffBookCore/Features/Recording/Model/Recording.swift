import Foundation
import SQLiteData

@Selection
struct Recording: Decodable, Identifiable {
    let id: UUID
    var riffID: Riff.ID?
    var sessionID: Session.ID?
    var name: String
    let mediaType: MediaType
    let fileName: String
    let createdAt: Date
    
    struct Create: Encodable {
        var riffID: UUID?
        var sessionID: UUID?
        var name: String
        let mediaType: MediaType
        let fileName: String
    }
    
    struct UpdateName: Encodable {
        let id: Recording.ID
        var name: String
        
        init(recording: Recording) {
            id = recording.id
            name = recording.name
        }
    }
    
    struct UpdateOwner: Encodable {
        let id: Recording.ID
        var riffID: Riff.ID
        
        init(recording: Recording, destinationRiffID: Riff.ID) {
            id = recording.id
            riffID = destinationRiffID
        }
    }
}
