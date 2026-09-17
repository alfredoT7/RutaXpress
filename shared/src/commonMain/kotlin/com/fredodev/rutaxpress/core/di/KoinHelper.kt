package com.fredodev.rutaxpress.core.di

import com.fredodev.rutaxpress.core.network.SessionTokenHolder
import com.fredodev.rutaxpress.features.auth.domain.repository.AuthRepository
import com.fredodev.rutaxpress.features.auth.presentation.AuthViewModel
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.flow.firstOrNull
import kotlinx.coroutines.runBlocking
import org.koin.core.context.startKoin
import org.koin.core.parameter.parametersOf
import org.koin.mp.KoinPlatform

fun initKoin() {
    startKoin {
        sharedModules()
    }
    hydrateSession()
}

private fun hydrateSession() {
    val koin = KoinPlatform.getKoin()
    val tokenHolder = koin.get<SessionTokenHolder>()
    val authRepository = koin.get<AuthRepository>()
    runBlocking {
        tokenHolder.set(authRepository.getToken().firstOrNull())
    }
}

fun getAuthViewModel(): AuthViewModel =
    KoinPlatform.getKoin().get { parametersOf(MainScope()) }
