package com.fredodev.rutaxpress.features.lineadmin.data.repository

import com.fredodev.rutaxpress.core.util.currentEpochSeconds
import com.fredodev.rutaxpress.features.lineadmin.domain.model.Route
import com.fredodev.rutaxpress.features.lineadmin.domain.model.RouteSnapshot

internal class RouteCache(
    private val nowEpochSeconds: () -> Long = ::currentEpochSeconds,
    private val ttlSeconds: Long = ROUTE_CACHE_TTL_SECONDS,
) {
    private var current: RouteSnapshot? = null

    fun snapshot(): RouteSnapshot? = current

    fun isFresh(): Boolean {
        val snapshot = current ?: return false
        val age = nowEpochSeconds() - snapshot.fetchedAtEpochSeconds
        return age in 0 until ttlSeconds
    }

    fun replace(routes: List<Route>) {
        current = RouteSnapshot(routes = routes, fetchedAtEpochSeconds = nowEpochSeconds())
    }

    fun update(route: Route) {
        val snapshot = current ?: return
        current = snapshot.copy(
            routes = snapshot.routes.map { if (it.id == route.id) route else it },
        )
    }

    companion object {
        const val ROUTE_CACHE_TTL_SECONDS = 30L
    }
}
