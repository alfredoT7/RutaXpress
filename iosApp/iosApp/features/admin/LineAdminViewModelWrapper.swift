import Foundation
import shared

@MainActor
final class LineAdminViewModelWrapper: ObservableObject {
    @Published private(set) var uiState: LineAdminUiState

    private let viewModel: LineAdminViewModel
    private var uiStateSubscription: FlowSubscription?

    init() {
        let vm = KoinHelperKt.getLineAdminViewModel()
        self.viewModel = vm
        self.uiState = vm.currentUiState()
    }

    func startObserving() {
        guard uiStateSubscription == nil else { return }
        uiStateSubscription = viewModel.observeUiState { [weak self] state in
            DispatchQueue.main.async {
                self?.uiState = state
            }
        }
    }

    func stopObserving() {
        uiStateSubscription?.cancel()
        uiStateSubscription = nil
    }

    func loadRoutes(forceRefresh: Bool = false) {
        viewModel.loadRoutes(forceRefresh: forceRefresh)
    }

    func selectRoute(_ route: Route) {
        viewModel.selectRoute(route: route)
    }

    func lookupUser(identifier: String) {
        viewModel.lookupUser(identifier: identifier)
    }

    func assignAdmin() {
        viewModel.assignAdmin()
    }

    func unassignAdmin() {
        viewModel.unassignAdmin()
    }

    func clearError() {
        viewModel.clearError()
    }

    func clearRouteRefreshError() {
        viewModel.clearRouteRefreshError()
    }

    func clearSuccess() {
        viewModel.clearSuccess()
    }

    deinit {
        uiStateSubscription?.cancel()
        viewModel.clear()
    }
}
