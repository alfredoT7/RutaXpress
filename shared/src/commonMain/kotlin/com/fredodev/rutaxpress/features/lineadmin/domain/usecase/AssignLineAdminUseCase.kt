package com.fredodev.rutaxpress.features.lineadmin.domain.usecase

import com.fredodev.rutaxpress.core.util.ResultState
import com.fredodev.rutaxpress.features.lineadmin.domain.model.Route
import com.fredodev.rutaxpress.features.lineadmin.domain.repository.LineAdminRepository

class AssignLineAdminUseCase(private val repository: LineAdminRepository) {
    suspend operator fun invoke(routeId: Long, userId: Long): ResultState<Route> =
        repository.assignAdmin(routeId, userId)
}
