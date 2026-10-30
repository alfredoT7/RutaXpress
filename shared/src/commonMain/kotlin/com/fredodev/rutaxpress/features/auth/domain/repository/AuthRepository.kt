package com.fredodev.rutaxpress.features.auth.domain.repository

import com.fredodev.rutaxpress.features.auth.domain.model.User
import com.fredodev.rutaxpress.core.util.ResultState
import com.fredodev.rutaxpress.features.auth.domain.model.SessionState
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.StateFlow

interface AuthRepository {
    val sessionState: StateFlow<SessionState>
    suspend fun login(identifier: String, password: String): ResultState<User>
    suspend fun register(name: String, username: String, email: String, password: String): ResultState<User>
    suspend fun logout()
    fun getSavedUserId(): Flow<String?>
    fun getToken(): Flow<String?>
    fun getRole(): Flow<String?>
}
