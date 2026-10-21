import Foundation
import SQLiteData

@Table
struct SongRecord: Identifiable {
    let id: UUID
    var name: String
    var tuning: String
    
    @Column(as: [Riff.ID].JSONRepresentation.self)
    var riffs: [Riff.ID]
    
    let creationDate: Date
    
    init(_ model: Song) {
        self.id = model.id
        self.name = model.name
        self.tuning = model.tuning
        self.riffs = model.riffs
        self.creationDate = model.creationDate
    }
}
