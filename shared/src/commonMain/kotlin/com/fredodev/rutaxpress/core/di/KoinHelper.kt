package com.fredodev.rutaxpress.core.di

import com.fredodev.rutaxpress.core.util.FlowSubscription
import com.fredodev.rutaxpress.features.auth.domain.model.SessionState
import com.fredodev.rutaxpress.features.auth.domain.repository.AuthRepository
import com.fredodev.rutaxpress.features.auth.presentation.AuthViewModel
import com.fredodev.rutaxpress.features.lineadmin.presentation.LineAdminViewModel
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.cancel
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch
import org.koin.core.context.startKoin
import org.koin.core.parameter.parametersOf
import org.koin.mp.KoinPlatform

fun initKoin() {
    startKoin {
        sharedModules()
    }
}

fun getAuthViewModel(): AuthViewModel =
    KoinPlatform.getKoin().get { parametersOf(MainScope()) }

fun getLineAdminViewModel(): LineAdminViewModel =
    KoinPlatform.getKoin().get { parametersOf(MainScope()) }

fun observeSession(onState: (SessionState) -> Unit): FlowSubscription {
    val authRepository = KoinPlatform.getKoin().get<AuthRepository>()
    val scope = MainScope()
    val job = scope.launch {
        authRepository.sessionState.collect { onState(it) }
    }
    return FlowSubscription {
        job.cancel()
        scope.cancel()
    }
}
