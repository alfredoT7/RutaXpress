package com.fredodev.rutaxpress.features.auth.data.remote

import com.fredodev.rutaxpress.features.auth.data.remote.dto.LoginRequestDto
import com.fredodev.rutaxpress.features.auth.data.remote.dto.LoginResponseDto
import com.fredodev.rutaxpress.features.auth.data.remote.dto.RegisterRequestDto
import com.fredodev.rutaxpress.features.auth.data.remote.dto.RegisterResponseDto
import io.ktor.client.HttpClient
import io.ktor.client.call.body
import io.ktor.client.request.post
import io.ktor.client.request.setBody
import io.ktor.http.ContentType
import io.ktor.http.contentType

class AuthApi(private val client: HttpClient) {

    suspend fun login(identifier: String, password: String): LoginResponseDto =
        client.post("$BASE_URL/login") {
            contentType(ContentType.Application.Json)
            setBody(LoginRequestDto(identifier, password))
        }.body()

    suspend fun register(name: String, username: String, email: String, password: String): RegisterResponseDto =
        client.post("$BASE_URL/register") {
            contentType(ContentType.Application.Json)
            setBody(RegisterRequestDto(name, username, email, password))
        }.body()

    companion object {
        private const val BASE_URL = "https://rutaxpressapi.onrender.com/api/users"
    }
}
