package com.fredodev.rutaxpress.core.di

import com.fredodev.rutaxpress.core.datastore.createDataStore
import com.fredodev.rutaxpress.core.network.createHttpClient
import org.koin.core.module.dsl.singleOf
import org.koin.dsl.module

val coreModule = module {
    single { createHttpClient() }
    single { createDataStore() }
}
