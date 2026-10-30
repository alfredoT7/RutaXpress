package com.fredodev.rutaxpress.core.network

import io.ktor.client.HttpClient
import io.ktor.client.plugins.HttpResponseValidator
import io.ktor.client.plugins.auth.Auth
import io.ktor.client.plugins.auth.providers.BearerTokens
import io.ktor.client.plugins.auth.providers.bearer
import io.ktor.client.plugins.HttpTimeout
import io.ktor.client.plugins.contentnegotiation.ContentNegotiation
import io.ktor.client.plugins.logging.LogLevel
import io.ktor.client.plugins.logging.Logging
import io.ktor.serialization.kotlinx.json.json
import io.ktor.http.HttpStatusCode
import com.fredodev.rutaxpress.core.util.JwtDecoder
import com.fredodev.rutaxpress.core.util.currentEpochSeconds
import kotlinx.serialization.json.Json

fun createHttpClient(tokenHolder: SessionTokenHolder): HttpClient = HttpClient {
    expectSuccess = true
    install(ContentNegotiation) {
        json(Json {
            ignoreUnknownKeys = true
            isLenient = true
        })
    }
    install(Logging) {
        level = LogLevel.INFO
    }
    install(HttpTimeout) {
        requestTimeoutMillis = 15_000
        connectTimeoutMillis = 10_000
        socketTimeoutMillis = 15_000
    }
    install(Auth) {
        bearer {
            loadTokens {
                tokenHolder.get()
                    ?.takeIf { it.isNotBlank() && !JwtDecoder.isExpired(it, currentEpochSeconds()) }
                    ?.let { BearerTokens(it, "") }
            }
            sendWithoutRequest { true }
        }
    }
    HttpResponseValidator {
        validateResponse { response ->
            if (response.status == HttpStatusCode.Unauthorized) tokenHolder.clearSession()
        }
    }
}
