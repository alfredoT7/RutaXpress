package com.fredodev.rutaxpress.features.lineadmin.domain.model

data class Route(
    val id: Long,
    val name: String,
    val code: String,
    val active: Boolean,
    val adminUserId: Long?,
)
