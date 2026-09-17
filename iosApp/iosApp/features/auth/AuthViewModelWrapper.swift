import Foundation
import shared

@MainActor
final class AuthViewModelWrapper: ObservableObject {
    @Published private(set) var uiState: AuthUiState

    private let viewModel: AuthViewModel

    init() {
        let vm = KoinHelperKt.getAuthViewModel()
        self.viewModel = vm
        self.uiState = vm.currentUiState()
        vm.observeUiState { [weak self] state in
            DispatchQueue.main.async {
                self?.uiState = state
            }
        }
    }

    func login(identifier: String, password: String) {
        viewModel.onLoginClick(identifier: identifier, password: password)
    }

    func register(name: String, username: String, email: String, password: String) {
        viewModel.onRegisterClick(name: name, username: username, email: email, password: password)
    }

    func clearError() {
        viewModel.clearError()
    }

    func resetSuccess() {
        viewModel.resetSuccess()
    }
}
