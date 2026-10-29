package com.fredodev.rutaxpress.features.lineadmin.domain.repository

import com.fredodev.rutaxpress.core.util.ResultState
import com.fredodev.rutaxpress.features.lineadmin.domain.model.Route
import com.fredodev.rutaxpress.features.lineadmin.domain.model.UserSummary

interface LineAdminRepository {
    suspend fun listRoutes(): ResultState<List<Route>>
    suspend fun lookupUser(identifier: String): ResultState<UserSummary>
    suspend fun assignAdmin(routeId: Long, userId: Long): ResultState<Route>
    suspend fun unassignAdmin(routeId: Long): ResultState<Route>
}
