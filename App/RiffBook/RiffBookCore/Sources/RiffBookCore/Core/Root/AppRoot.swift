import ComposableArchitecture
import SQLiteData

@MainActor
enum AppRoot {
    static let store: StoreOf<AppFeature> = {
        prepareDependencies {
            $0.defaultDatabase = try! appDatabase()
        }
        
        return Store(initialState: AppFeature.State()) {
            AppFeature()
        }
    }()
}
