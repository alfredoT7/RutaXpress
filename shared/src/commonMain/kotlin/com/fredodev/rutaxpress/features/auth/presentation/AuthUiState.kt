package com.fredodev.rutaxpress.features.auth.presentation

import com.fredodev.rutaxpress.features.auth.domain.model.User

data class AuthUiState(
    val isLoading: Boolean = false,
    val user: User? = null,
    val error: String? = null,
    val isLoginSuccess: Boolean = false,
    val isRegisterSuccess: Boolean = false,
)
