package com.fredodev.rutaxpress.features.lineadmin.domain.usecase

import com.fredodev.rutaxpress.core.util.ResultState
import com.fredodev.rutaxpress.features.lineadmin.domain.model.Route
import com.fredodev.rutaxpress.features.lineadmin.domain.repository.LineAdminRepository

class ListRoutesUseCase(private val repository: LineAdminRepository) {
    suspend operator fun invoke(): ResultState<List<Route>> = repository.listRoutes()
    fun cachedRoutes() = repository.cachedRoutes()
    fun shouldRefresh() = repository.shouldRefreshRoutes()
}
