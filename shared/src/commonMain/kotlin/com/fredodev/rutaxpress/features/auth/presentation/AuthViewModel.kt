package com.fredodev.rutaxpress.features.auth.presentation

import com.fredodev.rutaxpress.core.util.ResultState
import com.fredodev.rutaxpress.features.auth.domain.usecase.LoginUseCase
import com.fredodev.rutaxpress.features.auth.domain.usecase.RegisterUseCase
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch

class AuthViewModel(
    private val loginUseCase: LoginUseCase,
    private val registerUseCase: RegisterUseCase,
    private val scope: CoroutineScope,
) {
    private val _uiState = MutableStateFlow(AuthUiState())
    val uiState: StateFlow<AuthUiState> = _uiState.asStateFlow()

    fun onLoginClick(identifier: String, password: String) {
        scope.launch {
            _uiState.update { it.copy(isLoading = true, error = null) }
            when (val result = loginUseCase(identifier, password)) {
                is ResultState.Success -> _uiState.update {
                    it.copy(isLoading = false, user = result.data, isLoginSuccess = true)
                }
                is ResultState.Error -> _uiState.update {
                    it.copy(isLoading = false, error = result.message)
                }
                is ResultState.Loading -> Unit
            }
        }
    }

    fun onRegisterClick(name: String, username: String, email: String, password: String) {
        scope.launch {
            _uiState.update { it.copy(isLoading = true, error = null) }
            when (val result = registerUseCase(name, username, email, password)) {
                is ResultState.Success -> _uiState.update {
                    it.copy(isLoading = false, user = result.data, isRegisterSuccess = true)
                }
                is ResultState.Error -> _uiState.update {
                    it.copy(isLoading = false, error = result.message)
                }
                is ResultState.Loading -> Unit
            }
        }
    }

    fun currentUiState(): AuthUiState = _uiState.value

    fun clearError() {
        _uiState.update { it.copy(error = null) }
    }

    fun resetSuccess() {
        _uiState.update { it.copy(isLoginSuccess = false, isRegisterSuccess = false) }
    }

    fun observeUiState(onState: (AuthUiState) -> Unit) {
        scope.launch { uiState.collect { onState(it) } }
    }
}
