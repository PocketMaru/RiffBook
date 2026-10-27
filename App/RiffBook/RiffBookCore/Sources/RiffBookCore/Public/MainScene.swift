import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct MainScene: Scene {
    public init() {}
    public var body: some Scene {
        WindowGroup {
            AppView(store: AppRoot.store)
        }
    }
}
