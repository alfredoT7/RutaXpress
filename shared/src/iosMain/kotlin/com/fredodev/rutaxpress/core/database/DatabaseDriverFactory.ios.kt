package com.fredodev.rutaxpress.core.database

import app.cash.sqldelight.db.SqlDriver
import app.cash.sqldelight.driver.native.NativeSqliteDriver
import com.fredodev.rutaxpress.database.RutaXpressDatabase

actual class DatabaseDriverFactory {
    actual fun createDriver(): SqlDriver =
        NativeSqliteDriver(RutaXpressDatabase.Schema, "rutaxpress.db")
}
