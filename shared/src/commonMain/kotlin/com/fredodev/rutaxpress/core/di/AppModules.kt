package com.fredodev.rutaxpress.core.di

import com.fredodev.rutaxpress.features.auth.di.authModule
import com.fredodev.rutaxpress.features.lineadmin.di.lineAdminModule
import org.koin.core.KoinApplication

fun KoinApplication.sharedModules() {
    modules(
        coreModule,
        authModule,
        lineAdminModule,
    )
}
