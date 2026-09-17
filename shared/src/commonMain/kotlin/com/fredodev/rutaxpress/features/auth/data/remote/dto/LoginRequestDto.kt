package com.fredodev.rutaxpress.features.auth.data.remote.dto

import kotlinx.serialization.Serializable

@Serializable
data class LoginRequestDto(
    val identifier: String,
    val password: String,
)

@Serializable
data class LoginResponseDto(
    val id: Int,
    val name: String,
    val username: String,
    val email: String,
    val token: String,
    val message: String,
)

@Serializable
data class RegisterRequestDto(
    val name: String,
    val username: String,
    val email: String,
    val password: String,
)

@Serializable
data class RegisterResponseDto(
    val id: Int,
    val name: String,
    val username: String,
    val email: String,
    val token: String,
    val message: String,
)
