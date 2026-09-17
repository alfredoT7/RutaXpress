package com.fredodev.rutaxpress.features.auth.data.repository

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import com.fredodev.rutaxpress.core.network.SessionTokenHolder
import com.fredodev.rutaxpress.core.util.JwtDecoder
import com.fredodev.rutaxpress.core.util.ResultState
import com.fredodev.rutaxpress.features.auth.data.remote.AuthApi
import com.fredodev.rutaxpress.features.auth.domain.model.User
import com.fredodev.rutaxpress.features.auth.domain.repository.AuthRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

class AuthRepositoryImpl(
    private val api: AuthApi,
    private val dataStore: DataStore<Preferences>,
    private val tokenHolder: SessionTokenHolder,
) : AuthRepository {

    override suspend fun login(identifier: String, password: String): ResultState<User> = runCatching {
        val dto = api.login(identifier, password)
        val role = JwtDecoder.extractRole(dto.token) ?: "ROLE_USER"
        val user = User(id = dto.id, name = dto.name, username = dto.username, email = dto.email, role = role)
        persistSession(user.id.toString(), dto.token, role)
        ResultState.Success(user)
    }.getOrElse { ResultState.Error(it.message ?: "Login failed", it) }

    override suspend fun register(name: String, username: String, email: String, password: String): ResultState<User> = runCatching {
        val dto = api.register(name, username, email, password)
        val role = JwtDecoder.extractRole(dto.token) ?: "ROLE_USER"
        val user = User(id = dto.id, name = dto.name, username = dto.username, email = dto.email, role = role)
        persistSession(user.id.toString(), dto.token, role)
        ResultState.Success(user)
    }.getOrElse { ResultState.Error(it.message ?: "Registration failed", it) }

    override suspend fun logout() {
        tokenHolder.set(null)
        dataStore.edit {
            it.remove(USER_ID_KEY)
            it.remove(TOKEN_KEY)
            it.remove(ROLE_KEY)
        }
    }

    override fun getSavedUserId(): Flow<String?> =
        dataStore.data.map { it[USER_ID_KEY] }

    override fun getToken(): Flow<String?> =
        dataStore.data.map { it[TOKEN_KEY] }

    override fun getRole(): Flow<String?> =
        dataStore.data.map { it[ROLE_KEY] }

    private suspend fun persistSession(userId: String, token: String, role: String) {
        tokenHolder.set(token)
        dataStore.edit {
            it[USER_ID_KEY] = userId
            it[TOKEN_KEY] = token
            it[ROLE_KEY] = role
        }
    }

    companion object {
        private val USER_ID_KEY = stringPreferencesKey("user_id")
        private val TOKEN_KEY = stringPreferencesKey("auth_token")
        private val ROLE_KEY = stringPreferencesKey("auth_role")
    }
}
