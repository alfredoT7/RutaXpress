package com.fredodev.rutaxpress.features.lineadmin.domain.model

data class UserSummary(
    val id: Long,
    val name: String,
    val username: String,
    val email: String,
    val role: String,
)
