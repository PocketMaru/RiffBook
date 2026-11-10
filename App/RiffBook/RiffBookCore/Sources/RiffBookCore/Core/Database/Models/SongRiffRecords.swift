import Foundation
import SQLiteData

@Table
struct SongRiffRecords {
    var songID: Song.ID
    var riffID: Riff.ID
    var position: Int
}
