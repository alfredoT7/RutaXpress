package com.fredodev.rutaxpress.features.lineadmin.data.remote.dto

import kotlinx.serialization.Serializable

@Serializable
data class RouteDto(
    val id: Long,
    val name: String,
    val code: String,
    val description: String? = null,
    val color: String? = null,
    val active: Boolean,
    val adminUserId: Long? = null,
)
