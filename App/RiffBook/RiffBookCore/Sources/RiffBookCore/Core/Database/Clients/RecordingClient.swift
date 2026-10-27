import Foundation
import Dependencies

struct RecordingClient {
    var create: @Sendable (Recording.Create) async throws -> Recording
    var updateName: @Sendable (Recording.UpdateName) async throws -> Void
    var updateOwner: @Sendable (Recording.UpdateOwner) async throws -> Void
    var delete: @Sendable (Recording.ID) async throws -> Void
    var deleteMany: @Sendable (Set<Recording.ID>) async throws -> Void
}

extension RecordingClient: DependencyKey {
    static let liveValue: RecordingClient = {
        return RecordingClient(
            create: { recording in
                throw ClientError.notYetImplemented
            },
            updateName: { name in
                throw ClientError.notYetImplemented
            },
            updateOwner: { owner in
                throw ClientError.notYetImplemented
            },
            delete: { id in
                throw ClientError.notYetImplemented
            },
            deleteMany: { ids in
                throw ClientError.notYetImplemented
            }
        )
    }()
}

extension RecordingClient: TestDependencyKey {
    static let testValue = RecordingClient(
        create: { _ in
            throw ClientError.notYetImplemented
        },
        updateName: { _ in
            throw ClientError.notYetImplemented
        },
        updateOwner: { _ in
            throw ClientError.notYetImplemented
        },
        delete: { _ in
            throw ClientError.notYetImplemented
        },
        deleteMany: { _ in
            throw ClientError.notYetImplemented
        }
    )
}

extension DependencyValues {
    var recordingClient: RecordingClient {
        get { self[RecordingClient.self] }
        set { self[RecordingClient.self] = newValue }
    }
}
