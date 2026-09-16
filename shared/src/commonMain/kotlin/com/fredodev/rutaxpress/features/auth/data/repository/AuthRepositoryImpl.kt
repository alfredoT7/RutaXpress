package com.fredodev.rutaxpress.features.auth.data.repository

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import com.fredodev.rutaxpress.core.util.ResultState
import com.fredodev.rutaxpress.features.auth.data.remote.AuthApi
import com.fredodev.rutaxpress.features.auth.domain.model.User
import com.fredodev.rutaxpress.features.auth.domain.repository.AuthRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

class AuthRepositoryImpl(
    private val api: AuthApi,
    private val dataStore: DataStore<Preferences>,
) : AuthRepository {

    override suspend fun login(identifier: String, password: String): ResultState<User> = runCatching {
        val dto = api.login(identifier, password)
        val user = User(id = dto.id, name = dto.name, username = dto.username, email = dto.email)
        dataStore.edit { it[USER_ID_KEY] = user.id.toString() }
        ResultState.Success(user)
    }.getOrElse { ResultState.Error(it.message ?: "Login failed", it) }

    override suspend fun register(name: String, username: String, email: String, password: String): ResultState<User> = runCatching {
        val dto = api.register(name, username, email, password)
        val user = User(id = dto.id, name = dto.name, username = dto.username, email = dto.email)
        ResultState.Success(user)
    }.getOrElse { ResultState.Error(it.message ?: "Registration failed", it) }

    override suspend fun logout() {
        dataStore.edit { it.remove(USER_ID_KEY) }
    }

    override fun getSavedUserId(): Flow<String?> =
        dataStore.data.map { it[USER_ID_KEY] }

    companion object {
        private val USER_ID_KEY = stringPreferencesKey("user_id")
    }
}
