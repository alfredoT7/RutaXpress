package com.fredodev.rutaxpress.features.auth.domain.model

data class User(
    val id: Int,
    val name: String,
    val username: String,
    val email: String,
    val role: String,
)
