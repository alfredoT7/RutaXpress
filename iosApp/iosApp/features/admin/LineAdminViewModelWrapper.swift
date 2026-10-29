import Foundation
import shared

@MainActor
final class LineAdminViewModelWrapper: ObservableObject {
    @Published private(set) var uiState: LineAdminUiState

    private let viewModel: LineAdminViewModel

    init() {
        let vm = KoinHelperKt.getLineAdminViewModel()
        self.viewModel = vm
        self.uiState = vm.currentUiState()
        vm.observeUiState { [weak self] state in
            DispatchQueue.main.async {
                self?.uiState = state
            }
        }
    }

    func loadRoutes() {
        viewModel.loadRoutes()
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

    func clearSuccess() {
        viewModel.clearSuccess()
    }
}
