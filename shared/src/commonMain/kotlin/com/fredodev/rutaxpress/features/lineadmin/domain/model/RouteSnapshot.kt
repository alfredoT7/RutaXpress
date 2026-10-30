package com.fredodev.rutaxpress.features.lineadmin.domain.model

data class RouteSnapshot(
    val routes: List<Route>,
    val fetchedAtEpochSeconds: Long,
)
