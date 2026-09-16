package com.fredodev.rutaxpress.core.database

import android.content.Context
import app.cash.sqldelight.db.SqlDriver
import app.cash.sqldelight.driver.android.AndroidSqliteDriver
import com.fredodev.rutaxpress.database.RutaXpressDatabase

actual class DatabaseDriverFactory(private val context: Context) {
    actual fun createDriver(): SqlDriver =
        AndroidSqliteDriver(RutaXpressDatabase.Schema, context, "rutaxpress.db")
}
