package com.fredodev.rutaxpress.features.auth.domain.usecase

import com.fredodev.rutaxpress.features.auth.domain.model.User
import com.fredodev.rutaxpress.features.auth.domain.repository.AuthRepository
import com.fredodev.rutaxpress.core.util.ResultState

class LoginUseCase(private val repository: AuthRepository) {
    suspend operator fun invoke(identifier: String, password: String): ResultState<User> {
        if (identifier.isBlank() || password.isBlank()) {
            return ResultState.Error("Email/username and password required")
        }
        return repository.login(identifier, password)
    }
}
