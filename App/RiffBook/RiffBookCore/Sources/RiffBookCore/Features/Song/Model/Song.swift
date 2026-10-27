import Foundation
import SQLiteData

@Selection
struct Song: Decodable, Identifiable {
    let id: UUID
    var name: String
    var tuning: String = ""
    
    @Column(as: [Riff.ID].JSONRepresentation.self)
    var riffs: [Riff.ID] = []
    
    let creationDate: Date
    
    struct Create: Encodable {
        var name: String
        var tuning: String = ""
        var riffs: [Riff.ID] = []
    }
    
    struct Update: Encodable {
        let id: UUID
        var name: String
        var tuning: String
        var riffs: [Riff.ID]
        
        init(song: Song) {
            id = song.id
            name = song.name
            tuning = song.tuning
            riffs = song.riffs
        }
    }
}

extension Song {
    init(_ model: SongRecord) {
        self.id = model.id
        self.name = model.name
        self.tuning = model.tuning
        self.riffs = model.riffs
        self.creationDate = model.creationDate
    }
}
