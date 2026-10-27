import Foundation
import SQLiteData

struct RecordingRepo {
    @Dependency(\.defaultDatabase) private var database
    
    func create(model: Recording.Create) async throws -> Recording {
        @Dependency(\.uuid) var uuid
        @Dependency(\.date.now) var now
        
        let recording = Recording(
            id: uuid(),
            ownerType: model.ownerType,
            ownerID: model.ownerID,
            name: model.name,
            mediaType: model.mediaType,
            fileName: model.fileName,
            createdAt: now
        )
        
        let record = RecordingRecord(recording)
        
        try await database.write { db in
            try RecordingRecord
                .insert {
                    record
                }
                .execute(db)
        }
        return recording
    }
    
    func updateName(model: Recording.UpdateName) async throws {
        guard !model.name
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty
        else {
            throw RepoError.invalidName
        }
        
        let record = try await database.write { db in
            try RecordingRecord
                .where { $0.id.eq(model.id) }
                .update {
                    $0.name = model.name
                }
                .returning { $0 }
                .fetchOne(db)
        }
        
        guard record != nil else {
            throw RepoError.modelNotFound
        }
    }
    
    func updateOwner(model: Recording.UpdateOwner) async throws -> Void {
        let record = try await database.write { db in
            
            switch model.ownerType {
            case .session:
                let owner = try SessionRecord
                    .where{ $0.id.eq(model.ownerID)}
                    .fetchOne(db)
                guard owner != nil else {
                    throw RepoError.modelNotFound
                }
                
            case .riff:
                let owner = try RiffRecord
                    .where{ $0.id.eq(model.ownerID)}
                    .fetchOne(db)
                guard owner != nil else {
                    throw RepoError.modelNotFound
                }
            }
            
            return try RecordingRecord
                .where { $0.id.eq(model.id) }
                .update {
                    $0.ownerType = model.ownerType
                    $0.ownerID = model.ownerID
                }
                .returning { $0 }
                .fetchOne(db)
        }
        guard record != nil else {
            throw RepoError.modelNotFound
        }
    }
    
    func delete(id: Recording.ID) async throws {
        try await database.write { db in
            try RecordingRecord
                .where { $0.id.eq(id) }
                .delete()
                .execute(db)
        }
    }
    
    func deleteMany(ids: Set<Recording.ID>) async throws {
        try await database.write { db in
            try RecordingRecord
                .where{ $0.id.in(ids) }
                .delete()
                .execute(db)
        }
    }
    
    func deleteMany(ids: Set<Recording.ID>, db: Database) throws {
        try RecordingRecord
            .where{ $0.id.in(ids) }
            .delete()
            .execute(db)
    }
}
