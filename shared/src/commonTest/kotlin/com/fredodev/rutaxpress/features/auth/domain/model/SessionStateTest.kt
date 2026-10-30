package com.fredodev.rutaxpress.features.auth.domain.model

import kotlin.io.encoding.Base64
import kotlin.io.encoding.ExperimentalEncodingApi
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFalse
import kotlin.test.assertNull
import kotlin.test.assertTrue

@OptIn(ExperimentalEncodingApi::class)
class SessionStateTest {
    @Test
    fun restoringStateDoesNotClaimAuthentication() {
        val state = SessionState.restoring()

        assertTrue(state.isRestoring)
        assertFalse(state.isAuthenticated)
    }

    @Test
    fun validStoredTokenRestoresUserAndRole() {
        val state = SessionState.fromStoredValues(
            token = token("""{"role":"ROLE_ADMIN","exp":2000}"""),
            userId = "42",
            role = null,
            nowEpochSeconds = 1_000,
        )

        assertFalse(state.isRestoring)
        assertTrue(state.isAuthenticated)
        assertEquals("42", state.userId)
        assertEquals("ROLE_ADMIN", state.role)
    }

    @Test
    fun expiredOrMalformedTokenDoesNotRestoreSession() {
        val expired = SessionState.fromStoredValues(
            token = token("""{"exp":1000}"""),
            userId = "42",
            role = "ROLE_ADMIN",
            nowEpochSeconds = 1_000,
        )
        val malformed = SessionState.fromStoredValues("not-a-jwt", "42", "ROLE_ADMIN", 1_000)

        assertFalse(expired.isAuthenticated)
        assertNull(expired.userId)
        assertNull(expired.role)
        assertFalse(malformed.isAuthenticated)
    }

    @Test
    fun tokenWithoutExpirationRemainsUsableUntilServerRejectsIt() {
        val state = SessionState.fromStoredValues(
            token = token("""{"role":"ROLE_USER"}"""),
            userId = "8",
            role = null,
            nowEpochSeconds = 1_000,
        )

        assertTrue(state.isAuthenticated)
        assertEquals("ROLE_USER", state.role)
    }

    private fun token(payload: String): String {
        val encoded = Base64.UrlSafe.encode(payload.encodeToByteArray()).trimEnd('=')
        return "e30.$encoded.signature"
    }
}
