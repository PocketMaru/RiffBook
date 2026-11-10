import Foundation
import SQLiteData

@Table
struct EffectsRecord: Identifiable {
    let id: UUID
    let riffID: Riff.ID
    var effect: String
}

extension EffectsRecord {
    init(_ model: Effects) {
        self.id = model.id
        self.riffID = model.riffID
        self.effect = model.effect
    }
}
