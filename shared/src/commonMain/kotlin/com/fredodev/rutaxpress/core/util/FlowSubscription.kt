package com.fredodev.rutaxpress.core.util

class FlowSubscription internal constructor(private val cancelAction: () -> Unit) {
    fun cancel() = cancelAction()
}
