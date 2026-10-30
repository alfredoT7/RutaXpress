package com.fredodev.rutaxpress.core.network

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.map

const val TOKEN_PREFERENCE_KEY_NAME = "auth_token"

class SessionTokenHolder(private val dataStore: DataStore<Preferences>) {
    private val tokenKey = stringPreferencesKey(TOKEN_PREFERENCE_KEY_NAME)
    private val userIdKey = stringPreferencesKey("user_id")
    private val roleKey = stringPreferencesKey("auth_role")

    private var cached: String? = null
    private var hydrated = false

    fun set(token: String?) {
        cached = token
        hydrated = true
    }

    /** Reads the in-memory value if already hydrated; otherwise falls back to disk (covers cold app start / logout race). */
    suspend fun get(): String? {
        if (!hydrated) {
            cached = dataStore.data.map { it[tokenKey] }.first()
            hydrated = true
        }
        return cached
    }

    suspend fun clearSession() {
        set(null)
        dataStore.edit {
            it.remove(tokenKey)
            it.remove(userIdKey)
            it.remove(roleKey)
        }
    }
}
