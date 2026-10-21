import Foundation
import SQLiteData

@Table
struct RecordingRecord: Identifiable {
    let id: UUID
    var name: String
    let mediaType: MediaType
    let fileName: String
    let createdAt: Date
    
    init(_ model: Recording) {
        self.id = model.id
        self.name = model.name
        self.mediaType = model.mediaType
        self.fileName = model.fileName
        self.createdAt = model.createdAt
    }
}
