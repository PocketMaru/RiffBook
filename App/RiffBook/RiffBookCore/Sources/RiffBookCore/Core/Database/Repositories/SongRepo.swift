import Foundation
import SQLiteData

enum RepoError: Error {
    case modelNotFound
}
struct SongRepo {
    @Dependency(\.defaultDatabase) private var database
    
    func create(model: Song.Create) async throws -> Song {
        @Dependency(\.uuid) var uuid
        @Dependency(\.date.now) var now
        
        let song = Song(
            id: uuid(),
            name: model.name,
            tuning: model.tuning,
            riffs: model.riffs,
            creationDate: now
        )
        let record = SongRecord(song)
        try await database.write { db in
            try SongRecord
                .insert {
                    record
                }
                .execute(db)
        }
        return song
    }
    
    func update(model: Song.Update) async throws {
        let record = try await database.write { db in
            try SongRecord
                .where { $0.id.eq(model.id)}
                .update {
                    $0.name = model.name
                    $0.tuning = model.tuning
                    $0.riffs = #bind(model.riffs)
                }
                .returning { $0 }
                .fetchOne(db)
        }
        guard record != nil else {
            throw RepoError.modelNotFound
        }
    }
    
    func delete(id: Song.ID) async throws {
        try await database.write { db in
            try SongRecord
                .where { $0.id.eq(id) }
                .delete()
                .execute(db)
        }
    }
}

