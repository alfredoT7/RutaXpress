package com.fredodev.rutaxpress.core.network

import kotlinx.coroutines.flow.MutableStateFlow

class SessionTokenHolder {
    private val _token = MutableStateFlow<String?>(null)

    fun get(): String? = _token.value

    fun set(token: String?) {
        _token.value = token
    }
}
