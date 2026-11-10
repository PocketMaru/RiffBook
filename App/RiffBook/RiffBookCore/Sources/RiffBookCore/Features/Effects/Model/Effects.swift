import Foundation
import SQLiteData

@Selection
struct Effects: Identifiable {
    let id: UUID
    let riffID: Riff.ID
    var effect: String
}
