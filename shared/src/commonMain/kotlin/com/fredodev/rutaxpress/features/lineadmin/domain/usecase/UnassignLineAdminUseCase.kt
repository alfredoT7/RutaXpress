package com.fredodev.rutaxpress.features.lineadmin.domain.usecase

import com.fredodev.rutaxpress.core.util.ResultState
import com.fredodev.rutaxpress.features.lineadmin.domain.model.Route
import com.fredodev.rutaxpress.features.lineadmin.domain.repository.LineAdminRepository

class UnassignLineAdminUseCase(private val repository: LineAdminRepository) {
    suspend operator fun invoke(routeId: Long): ResultState<Route> =
        repository.unassignAdmin(routeId)
}
