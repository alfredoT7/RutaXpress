package com.fredodev.rutaxpress.features.lineadmin.data.remote.dto

import kotlinx.serialization.Serializable

@Serializable
data class UserSummaryDto(
    val id: Long,
    val name: String,
    val username: String,
    val email: String,
    val role: String,
)
