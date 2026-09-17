package com.fredodev.rutaxpress.features.auth.domain.usecase

import com.fredodev.rutaxpress.core.util.ResultState
import com.fredodev.rutaxpress.features.auth.domain.model.User
import com.fredodev.rutaxpress.features.auth.domain.repository.AuthRepository

class RegisterUseCase(private val repository: AuthRepository) {
    suspend operator fun invoke(
        name: String,
        username: String,
        email: String,
        password: String,
    ): ResultState<User> {
        if (name.isBlank() || username.isBlank() || email.isBlank() || password.isBlank()) {
            return ResultState.Error("All fields required")
        }
        if (password.length < 6) {
            return ResultState.Error("Password must be at least 6 characters")
        }
        return repository.register(name, username, email, password)
    }
}
