package com.fredodev.rutaxpress.core.di

import com.fredodev.rutaxpress.features.auth.presentation.AuthViewModel
import kotlinx.coroutines.MainScope
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
