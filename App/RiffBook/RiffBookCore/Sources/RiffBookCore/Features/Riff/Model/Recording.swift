import Foundation
import SQLiteData

@Selection
struct Recording: Decodable, Identifiable {
    let id: UUID
    var name: String
    let mediaType: MediaType
    let fileName: String
    let createdAt: Date
    
    struct Create: Encodable {
        var name: String
        let mediaType: MediaType
        let fileName: String
    }
    
    struct Update: Encodable {
        var name: String
        
        init(recording: Recording) {
            name = recording.name
        }
    }
}
