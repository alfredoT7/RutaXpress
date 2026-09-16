package com.fredodev.rutaxpress.features.auth.domain.repository

import com.fredodev.rutaxpress.features.auth.domain.model.User
import com.fredodev.rutaxpress.core.util.ResultState
import kotlinx.coroutines.flow.Flow

interface AuthRepository {
    suspend fun login(identifier: String, password: String): ResultState<User>
    suspend fun register(name: String, username: String, email: String, password: String): ResultState<User>
    suspend fun logout()
    fun getSavedUserId(): Flow<String?>
}
