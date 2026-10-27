import Foundation
import SQLiteData

enum RecordingOwnerType: String, Codable, QueryBindable {
    case session
    case riff
}

@Selection
struct Recording: Decodable, Identifiable {
    let id: UUID
    var ownerType: RecordingOwnerType
    var ownerID: UUID
    var name: String
    let mediaType: MediaType
    let fileName: String
    let createdAt: Date
    
    struct Create: Encodable {
        var name: String
        var ownerType: RecordingOwnerType
        var ownerID: UUID
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
        var ownerType: RecordingOwnerType
        var ownerID: UUID
        
        init(recording: Recording) {
            id = recording.id
            ownerType = recording.ownerType
            ownerID = recording.ownerID
        }
    }
}
