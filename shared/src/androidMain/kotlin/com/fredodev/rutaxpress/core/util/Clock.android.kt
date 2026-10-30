package com.fredodev.rutaxpress.core.util

actual fun currentEpochSeconds(): Long = System.currentTimeMillis() / 1_000L
