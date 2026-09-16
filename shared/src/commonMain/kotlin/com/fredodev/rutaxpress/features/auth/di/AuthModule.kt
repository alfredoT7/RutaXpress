package com.fredodev.rutaxpress.features.auth.di

import com.fredodev.rutaxpress.features.auth.data.remote.AuthApi
import com.fredodev.rutaxpress.features.auth.data.repository.AuthRepositoryImpl
import com.fredodev.rutaxpress.features.auth.domain.repository.AuthRepository
import com.fredodev.rutaxpress.features.auth.domain.usecase.LoginUseCase
import com.fredodev.rutaxpress.features.auth.domain.usecase.RegisterUseCase
import com.fredodev.rutaxpress.features.auth.presentation.AuthViewModel
import kotlinx.coroutines.CoroutineScope
import org.koin.dsl.module

val authModule = module {
    single { AuthApi(get()) }
    single<AuthRepository> { AuthRepositoryImpl(get(), get()) }
    single { LoginUseCase(get()) }
    single { RegisterUseCase(get()) }
    factory { (scope: CoroutineScope) -> AuthViewModel(get(), get(), scope) }
}
