import Foundation
import SQLiteData

@Table
struct RecordingRecord: Identifiable {
    let id: UUID
    var name: String
    var ownerType: RecordingOwnerType
    var ownerID: UUID
    let mediaType: MediaType
    let fileName: String
    let createdAt: Date
    
    init(_ model: Recording) {
        self.id = model.id
        self.name = model.name
        self.ownerType = model.ownerType
        self.ownerID = model.ownerID
        self.mediaType = model.mediaType
        self.fileName = model.fileName
        self.createdAt = model.createdAt
    }
}
