package com.fredodev.rutaxpress.features.auth.domain.model

import com.fredodev.rutaxpress.core.util.JwtDecoder
import com.fredodev.rutaxpress.core.util.currentEpochSeconds

data class SessionState(
    val isRestoring: Boolean,
    val isAuthenticated: Boolean,
    val userId: String? = null,
    val role: String? = null,
) {
    companion object {
        fun restoring() = SessionState(isRestoring = true, isAuthenticated = false)
        fun unauthenticated() = SessionState(isRestoring = false, isAuthenticated = false)

        fun fromStoredValues(
            token: String?,
            userId: String?,
            role: String?,
            nowEpochSeconds: Long = currentEpochSeconds(),
        ): SessionState {
            val usableToken = token?.takeIf { it.isNotBlank() && !JwtDecoder.isExpired(it, nowEpochSeconds) }
                ?: return unauthenticated()

            return SessionState(
                isRestoring = false,
                isAuthenticated = true,
                userId = userId,
                role = role ?: JwtDecoder.extractRole(usableToken) ?: "ROLE_USER",
            )
        }
    }
}
