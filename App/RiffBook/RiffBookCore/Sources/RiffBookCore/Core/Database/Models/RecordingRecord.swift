import Foundation
import SQLiteData

@Table
struct RecordingRecord: Identifiable {
    let id: UUID
    var riffID: Riff.ID?
    var sessionID: Session.ID?
    var name: String
    let mediaType: MediaType
    let fileName: String
    let createdAt: Date
}

extension RecordingRecord {
    init(_ model: Recording) {
        self.id = model.id
        self.riffID = model.riffID
        self.sessionID = model.sessionID
        self.name = model.name
        self.mediaType = model.mediaType
        self.fileName = model.fileName
        self.createdAt = model.createdAt
    }
}
