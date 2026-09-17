import SwiftUI
import shared

@main
struct RutaXpressApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    await Task.detached(priority: .userInitiated) {
                        KoinHelper().startKoin()
                    }.value
                    KoinBootstrap.shared.markReady()
                }
        }
    }
}
