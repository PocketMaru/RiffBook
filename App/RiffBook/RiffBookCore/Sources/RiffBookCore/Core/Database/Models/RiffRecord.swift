import Foundation
import SQLiteData

@Table
struct RiffRecord: Identifiable {
    let id: UUID
    var name: String
    var instrument: String
    
    @Column(as: [Effects].JSONRepresentation.self)
    var effects: [Effects]
    
    var key: String
    var tuning: String
    var description: String
    
    @Column(as: [Recording.ID].JSONRepresentation.self)
    var recordings: [Recording.ID]
    
    var favorite: Recording.ID?
    var updatedAt: Date
    let createdAt: Date
    
    init(_ model: Riff) {
        self.id = model.id
        self.name = model.name
        self.instrument = model.instrument
        self.effects = model.effects
        self.key = model.key
        self.tuning = model.tuning
        self.description = model.description
        self.recordings = model.recordings
        self.favorite = model.favorite
        self.updatedAt = model.updatedAt
        self.createdAt = model.createdAt
    }
}
