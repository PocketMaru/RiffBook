import Foundation
import SQLiteData

@Selection
struct Song: Decodable, Identifiable {
    let id: UUID
    var name: String
    var tuning: String = ""
    let creationDate: Date
    
    struct Create: Encodable {
        var name: String
        var tuning: String = ""
    }
    
    struct Update: Encodable {
        let id: UUID
        var name: String
        var tuning: String
        
        init(song: Song) {
            id = song.id
            name = song.name
            tuning = song.tuning
        }
    }
}
