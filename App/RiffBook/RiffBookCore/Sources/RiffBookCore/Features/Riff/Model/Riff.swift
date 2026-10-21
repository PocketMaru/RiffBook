import Foundation
import SQLiteData

enum MediaType: String, Codable, QueryBindable {
    case audio
    case video
}

enum Effects: String, Codable {
    case clean
    case distortion
    case other
}

@Selection
struct Riff: Decodable, Identifiable {
    let id: UUID
    var name: String
    var instrument = ""
    
    @Column(as: [Effects].JSONRepresentation.self)
    var effects: [Effects] = []
    
    var key = ""
    var tuning = ""
    var description = ""
    
    @Column(as: [Recording.ID].JSONRepresentation.self)
    var recordings: [Recording.ID] = []
    
    var favorite: Recording.ID?
    var updatedAt: Date
    let createdAt: Date
    
    struct Create: Encodable {
        var name: String
        var instrument = ""
        var effects: [Effects] = []
        var key = ""
        var tuning = ""
        var description = ""
        var recordings: [Recording.ID] = []
    }
    
    struct Update: Encodable {
        let id: UUID
        var name: String
        var instrument: String
        var effects: [Effects]
        var key: String
        var tuning: String
        var description: String
        var recordings: [Recording.ID]
        var favorite: Recording.ID?
        
        init(riff: Riff) {
            id = riff.id
            name = riff.name
            instrument = riff.instrument
            effects = riff.effects
            key = riff.key
            tuning = riff.tuning
            description = riff.description
            recordings = riff.recordings
            favorite = riff.favorite
        }
    }
}
