package com.fredodev.rutaxpress.core.util

import kotlin.io.encoding.Base64
import kotlin.io.encoding.ExperimentalEncodingApi
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.jsonPrimitive

@OptIn(ExperimentalEncodingApi::class)
object JwtDecoder {

    fun extractRole(token: String): String? = runCatching {
        val payload = token.split(".").getOrNull(1) ?: return null
        val decoded = Base64.UrlSafe.decode(padBase64(payload)).decodeToString()
        val json = Json.parseToJsonElement(decoded) as JsonObject
        json["role"]?.jsonPrimitive?.content
    }.getOrNull()

    private fun padBase64(value: String): String {
        val remainder = value.length % 4
        return if (remainder == 0) value else value + "=".repeat(4 - remainder)
    }
}
