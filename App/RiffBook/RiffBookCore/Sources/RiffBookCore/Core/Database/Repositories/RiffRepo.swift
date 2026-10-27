import Foundation
import SQLiteData

struct RiffRepo {
    @Dependency(\.defaultDatabase) private var database
    
    func create(model: Riff.Create) async throws -> Riff {
        @Dependency(\.uuid) var uuid
        @Dependency(\.date.now) var now
        
        let riff = Riff(
            id: uuid(),
            name: model.name,
            instrument: model.instrument,
            effects: model.effects,
            key: model.key,
            tuning: model.tuning,
            description: model.description,
            recordings: model.recordings,
            favorite: nil,
            updatedAt: now,
            createdAt: now
        )
        
        let record = RiffRecord(riff)
        try await database.write { db in
            try RiffRecord
                .insert {
                    record
                }
                .execute(db)
        }
        return riff
    }
    
    func update(model: Riff.Update) async throws {
        @Dependency(\.date.now) var now
        
        if let favorite = model.favorite {
            guard model.recordings.contains(favorite) else {
                throw RepoError.invalidFavorite
            }
        }
        
        let record = try await database.write { db in
            
            let recordings = try RecordingRecord
                .where { $0.id.in(model.recordings) }
                .fetchAll(db)
            let requestedIDs = Set(model.recordings)
            let existingIDs = Set(recordings.map(\.id))
            guard requestedIDs == existingIDs else {
                throw RepoError.modelNotFound
            }
            
            return try RiffRecord
                .where { $0.id.eq(model.id) }
                .update {
                    $0.name = model.name
                    $0.instrument = model.instrument
                    $0.effects = #bind(model.effects)
                    $0.key = model.key
                    $0.tuning = model.tuning
                    $0.description = model.description
                    $0.recordings = #bind(model.recordings)
                    $0.favorite = model.favorite
                    $0.updatedAt = now
                }
                .returning { $0 }
                .fetchOne(db)
        }
        guard record != nil else {
            throw RepoError.modelNotFound
        }
    }
    
    func delete(id: Riff.ID) async throws {
        let recRepo = RecordingRepo()
        try await database.write { db in
            let riff = try RiffRecord
                .where { $0.id.eq(id) }
                .fetchOne(db)
            
            guard let riff else {
                throw RepoError.modelNotFound
            }
            
            
            let recordingSet = Set(riff.recordings)
            
            try RiffRecord
                .delete(riff)
                .execute(db)
            
            try recRepo.deleteMany(ids: recordingSet, db: db)
        }
    }
}
