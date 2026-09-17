import Foundation
import shared

class KoinHelper {
    func startKoin() {
        KoinHelperKt.doInitKoin()
    }
}

@MainActor
final class KoinBootstrap: ObservableObject {
    static let shared = KoinBootstrap()
    @Published private(set) var isReady = false

    private init() {}

    func markReady() {
        isReady = true
    }
}
