package com.fredodev.rutaxpress.features.lineadmin.data.repository

import com.fredodev.rutaxpress.core.util.ResultState
import com.fredodev.rutaxpress.features.lineadmin.data.remote.LineAdminApi
import com.fredodev.rutaxpress.features.lineadmin.data.remote.dto.RouteDto
import com.fredodev.rutaxpress.features.lineadmin.data.remote.dto.UserSummaryDto
import com.fredodev.rutaxpress.features.lineadmin.domain.model.Route
import com.fredodev.rutaxpress.features.lineadmin.domain.model.UserSummary
import com.fredodev.rutaxpress.features.lineadmin.domain.repository.LineAdminRepository

class LineAdminRepositoryImpl(private val api: LineAdminApi) : LineAdminRepository {

    override suspend fun listRoutes(): ResultState<List<Route>> = runCatching {
        ResultState.Success(api.listRoutes().map { it.toDomain() })
    }.getOrElse { ResultState.Error(it.message ?: "No se pudieron cargar las rutas", it) }

    override suspend fun lookupUser(identifier: String): ResultState<UserSummary> = runCatching {
        ResultState.Success(api.lookupUser(identifier).toDomain())
    }.getOrElse { ResultState.Error(it.message ?: "Usuario no encontrado", it) }

    override suspend fun assignAdmin(routeId: Long, userId: Long): ResultState<Route> = runCatching {
        ResultState.Success(api.assignAdmin(routeId, userId).toDomain())
    }.getOrElse { ResultState.Error(it.message ?: "No se pudo asignar el encargado", it) }

    override suspend fun unassignAdmin(routeId: Long): ResultState<Route> = runCatching {
        ResultState.Success(api.unassignAdmin(routeId).toDomain())
    }.getOrElse { ResultState.Error(it.message ?: "No se pudo quitar el encargado", it) }

    private fun RouteDto.toDomain() = Route(id = id, name = name, code = code, active = active, adminUserId = adminUserId)

    private fun UserSummaryDto.toDomain() = UserSummary(id = id, name = name, username = username, email = email, role = role)
}
