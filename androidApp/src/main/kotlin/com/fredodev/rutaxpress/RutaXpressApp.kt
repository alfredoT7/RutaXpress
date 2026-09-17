package com.fredodev.rutaxpress

import android.app.Application
import com.fredodev.rutaxpress.core.datastore.initDataStore
import com.fredodev.rutaxpress.core.di.sharedModules
import org.koin.android.ext.koin.androidContext
import org.koin.core.context.startKoin

class RutaXpressApp : Application() {
    override fun onCreate() {
        super.onCreate()
        initDataStore(this)
        startKoin {
            androidContext(this@RutaXpressApp)
            sharedModules()
        }
    }
}
