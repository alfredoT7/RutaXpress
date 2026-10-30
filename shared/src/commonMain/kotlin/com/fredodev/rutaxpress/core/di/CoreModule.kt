package com.fredodev.rutaxpress.core.di

import com.fredodev.rutaxpress.core.datastore.createDataStore
import com.fredodev.rutaxpress.core.network.SessionTokenHolder
import com.fredodev.rutaxpress.core.network.createHttpClient
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import org.koin.core.qualifier.named
import org.koin.dsl.module

val coreModule = module {
    single(named("applicationScope")) { CoroutineScope(SupervisorJob() + Dispatchers.Main) }
    single { createDataStore() }
    single { SessionTokenHolder(get()) }
    single { createHttpClient(get()) }
}
