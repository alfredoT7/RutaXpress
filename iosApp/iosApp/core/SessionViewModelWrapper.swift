import Foundation
import shared

@MainActor
final class SessionViewModelWrapper: ObservableObject {
    @Published private(set) var sessionState: SessionState?

    private var subscription: FlowSubscription?

    func start() {
        guard subscription == nil else { return }
        subscription = KoinHelperKt.observeSession { [weak self] state in
            DispatchQueue.main.async {
                self?.sessionState = state
            }
        }
    }

    func stop() {
        subscription?.cancel()
        subscription = nil
    }

    deinit {
        subscription?.cancel()
    }
}
