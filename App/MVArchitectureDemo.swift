import SwiftUI

@main
struct MVArchitectureDemo: App {
    @State private var container = AppContainer()

    var body: some Scene {
        WindowGroup {
            RootView(container: container)
        }
    }
}
