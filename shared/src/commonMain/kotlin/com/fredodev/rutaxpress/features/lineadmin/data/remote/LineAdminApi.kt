package com.fredodev.rutaxpress.features.lineadmin.data.remote

import com.fredodev.rutaxpress.features.lineadmin.data.remote.dto.RouteDto
import com.fredodev.rutaxpress.features.lineadmin.data.remote.dto.UserSummaryDto
import io.ktor.client.HttpClient
import io.ktor.client.call.body
import io.ktor.client.request.delete
import io.ktor.client.request.get
import io.ktor.client.request.parameter
import io.ktor.client.request.put
import io.ktor.client.request.setBody
import io.ktor.http.ContentType
import io.ktor.http.contentType
import kotlinx.serialization.Serializable

class LineAdminApi(private val client: HttpClient) {

    suspend fun listRoutes(): List<RouteDto> =
        client.get("$BASE_URL/routes").body()

    suspend fun lookupUser(identifier: String): UserSummaryDto =
        client.get("$BASE_URL/users/lookup") {
            parameter("identifier", identifier)
        }.body()

    suspend fun assignAdmin(routeId: Long, userId: Long): RouteDto =
        client.put("$BASE_URL/routes/$routeId/admin") {
            contentType(ContentType.Application.Json)
            setBody(AssignAdminBody(userId))
        }.body()

    suspend fun unassignAdmin(routeId: Long): RouteDto =
        client.delete("$BASE_URL/routes/$routeId/admin").body()

    @Serializable
    private data class AssignAdminBody(val userId: Long)

    companion object {
        private const val BASE_URL = "https://apiruta.softcraftbol.com/api"
    }
}
