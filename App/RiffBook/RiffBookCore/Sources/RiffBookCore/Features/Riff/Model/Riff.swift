import Foundation
import SQLiteData

enum MediaType: String, Codable, QueryBindable {
    case audio
    case video
}

@Selection
struct Riff: Decodable, Identifiable {
    let id: UUID
    var name: String
    var instrument = ""
    var key = ""
    var tuning = ""
    var description = ""
    var favorite: Recording.ID?
    var updatedAt: Date
    let createdAt: Date
    
    struct Create: Encodable {
        var name: String
        var instrument = ""
        var key = ""
        var tuning = ""
        var description = ""
    }
    
    struct Update: Encodable {
        let id: UUID
        var name: String
        var instrument: String
        var key: String
        var tuning: String
        var description: String
        var favorite: Recording.ID?
        
        init(riff: Riff) {
            id = riff.id
            name = riff.name
            instrument = riff.instrument
            key = riff.key
            tuning = riff.tuning
            description = riff.description
            favorite = riff.favorite
        }
    }
}
