package com.fredodev.rutaxpress.core.util

import kotlinx.coroutines.CoroutineDispatcher

expect object DispatcherProvider {
    val io: CoroutineDispatcher
    val main: CoroutineDispatcher
    val default: CoroutineDispatcher
}
