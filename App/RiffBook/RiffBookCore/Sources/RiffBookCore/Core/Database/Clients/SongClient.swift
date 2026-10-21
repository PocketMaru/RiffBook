import Foundation
import Dependencies

enum SongClientError: Error {
    case notYetImplemented
}

struct SongClient {
    var create: @Sendable (Song.Create) async throws -> Song
    var update: @Sendable (Song.Update) async throws -> Void
    var delete: @Sendable (_ id: Song.ID) async throws -> Void
}

extension SongClient: DependencyKey {
    static let liveValue: SongClient = {
        let repo = SongRepo()
        return SongClient(
            create: { song in
                try await repo.create(model: song)
            },
            update: { updated in
                try await repo.update(model: updated)
            },
            delete: { songID in
                try await repo.delete(id: songID)
            }
        )
    }()
}

extension SongClient: TestDependencyKey {
    static let testValue = SongClient(
        create: { _ in
            throw SongClientError.notYetImplemented
        },
        update: { _ in
            throw SongClientError.notYetImplemented
        },
        delete: { _ in
            throw SongClientError.notYetImplemented
        }
    )
}
extension DependencyValues {
    var songClient: SongClient {
        get { self[SongClient.self] }
        set { self[SongClient.self] = newValue }
    }
}
