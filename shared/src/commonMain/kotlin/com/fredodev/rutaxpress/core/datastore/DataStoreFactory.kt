package com.fredodev.rutaxpress.core.datastore

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences

expect fun createDataStore(): DataStore<Preferences>

internal const val DATASTORE_FILE_NAME = "rutaxpress.preferences_pb"
