import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct ContentView: View {
    public var body: some View {
        VStack {
            AppView(store: AppRoot.store)
        }
        .padding()
    }
    public init() {}
}

#Preview {
    ContentView()
}
