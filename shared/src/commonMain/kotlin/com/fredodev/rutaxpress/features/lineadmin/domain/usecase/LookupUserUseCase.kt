package com.fredodev.rutaxpress.features.lineadmin.domain.usecase

import com.fredodev.rutaxpress.core.util.ResultState
import com.fredodev.rutaxpress.features.lineadmin.domain.model.UserSummary
import com.fredodev.rutaxpress.features.lineadmin.domain.repository.LineAdminRepository

class LookupUserUseCase(private val repository: LineAdminRepository) {
    suspend operator fun invoke(identifier: String): ResultState<UserSummary> {
        if (identifier.isBlank()) return ResultState.Error("Ingresa un usuario o email")
        return repository.lookupUser(identifier)
    }
}
