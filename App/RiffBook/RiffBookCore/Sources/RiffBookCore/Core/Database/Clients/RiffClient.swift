import Foundation
import Dependencies

struct RiffClient {
    var create: @Sendable (Riff.Create) async throws -> Riff
    var update: @Sendable (Riff.Update) async throws -> Void
    var delete: @Sendable (Riff.ID) async throws -> Void
}

extension RiffClient: DependencyKey {
    static let liveValue: RiffClient = {
        let repo = RiffRepo()
        return RiffClient(
            create: { riff in
                try await repo.create(model: riff)
            },
            update: { updated in
                try await repo.update(model: updated)
            },
            delete: { id in
                try await repo.delete(id: id)
            }
        )
    }()
}

extension RiffClient: TestDependencyKey {
    static let testValue = RiffClient(
        create: { _ in
            throw ClientError.notYetImplemented
        },
        update: { _ in
            throw ClientError.notYetImplemented
        },
        delete: { _ in
            throw ClientError.notYetImplemented
        }
    )
}

extension DependencyValues {
    var riffClient: RiffClient {
        get { self[RiffClient.self] }
        set { self[RiffClient.self] = newValue }
    }
}
