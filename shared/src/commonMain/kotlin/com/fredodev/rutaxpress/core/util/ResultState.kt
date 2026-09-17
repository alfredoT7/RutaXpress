package com.fredodev.rutaxpress.core.util

sealed class ResultState<out T> {
    data class Success<T>(val data: T) : ResultState<T>()
    data class Error(val message: String, val throwable: Throwable? = null) : ResultState<Nothing>()
    data object Loading : ResultState<Nothing>()
}
