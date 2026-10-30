package com.fredodev.rutaxpress.features.lineadmin.presentation

import com.fredodev.rutaxpress.core.util.ResultState
import com.fredodev.rutaxpress.core.util.FlowSubscription
import com.fredodev.rutaxpress.features.lineadmin.domain.model.Route
import com.fredodev.rutaxpress.features.lineadmin.domain.usecase.AssignLineAdminUseCase
import com.fredodev.rutaxpress.features.lineadmin.domain.usecase.ListRoutesUseCase
import com.fredodev.rutaxpress.features.lineadmin.domain.usecase.LookupUserUseCase
import com.fredodev.rutaxpress.features.lineadmin.domain.usecase.UnassignLineAdminUseCase
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.cancel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch

class LineAdminViewModel(
    private val listRoutesUseCase: ListRoutesUseCase,
    private val lookupUserUseCase: LookupUserUseCase,
    private val assignLineAdminUseCase: AssignLineAdminUseCase,
    private val unassignLineAdminUseCase: UnassignLineAdminUseCase,
    private val scope: CoroutineScope,
) {
    private val _uiState = MutableStateFlow(LineAdminUiState())
    val uiState: StateFlow<LineAdminUiState> = _uiState.asStateFlow()

    fun loadRoutes(forceRefresh: Boolean = false) {
        val currentState = _uiState.value
        if (!forceRefresh && (currentState.isLoadingRoutes || currentState.isRefreshingRoutes)) return
        val cached = listRoutesUseCase.cachedRoutes()
        val shouldRefresh = forceRefresh || listRoutesUseCase.shouldRefresh()
        _uiState.update {
            it.copy(
                routes = cached?.routes ?: it.routes,
                isLoadingRoutes = cached == null && shouldRefresh,
                isRefreshingRoutes = cached != null && shouldRefresh,
                routeRefreshError = null,
                error = null,
            )
        }
        if (!shouldRefresh) return

        scope.launch {
            when (val result = listRoutesUseCase()) {
                is ResultState.Success -> _uiState.update {
                    val selectedId = it.selectedRoute?.id
                    val updatedSelection = result.data.firstOrNull { route -> route.id == selectedId }
                    it.copy(
                        isLoadingRoutes = false,
                        isRefreshingRoutes = false,
                        routeRefreshError = null,
                        routes = result.data,
                        selectedRoute = updatedSelection ?: it.selectedRoute,
                    )
                }
                is ResultState.Error -> {
                    val hasCachedRoutes = cached != null
                    _uiState.update {
                        it.copy(
                            isLoadingRoutes = false,
                            isRefreshingRoutes = false,
                            routeRefreshError = if (hasCachedRoutes) result.message else null,
                            error = if (hasCachedRoutes) null else result.message,
                        )
                    }
                }
                is ResultState.Loading -> Unit
            }
        }
    }

    fun selectRoute(route: Route) {
        _uiState.update { it.copy(selectedRoute = route, foundUser = null, successMessage = null, error = null) }
    }

    fun lookupUser(identifier: String) {
        scope.launch {
            _uiState.update { it.copy(isLookingUpUser = true, error = null, foundUser = null) }
            when (val result = lookupUserUseCase(identifier)) {
                is ResultState.Success -> _uiState.update { it.copy(isLookingUpUser = false, foundUser = result.data) }
                is ResultState.Error -> _uiState.update { it.copy(isLookingUpUser = false, error = result.message) }
                is ResultState.Loading -> Unit
            }
        }
    }

    fun assignAdmin() {
        val route = _uiState.value.selectedRoute ?: return
        val user = _uiState.value.foundUser ?: return
        scope.launch {
            _uiState.update { it.copy(isSubmitting = true, error = null) }
            when (val result = assignLineAdminUseCase(route.id, user.id)) {
                is ResultState.Success -> _uiState.update {
                    it.copy(
                        isSubmitting = false,
                        selectedRoute = result.data,
                        foundUser = null,
                        successMessage = "${user.name} ahora es encargado de ${result.data.name}",
                        routes = it.routes.map { r -> if (r.id == result.data.id) result.data else r },
                    )
                }
                is ResultState.Error -> _uiState.update { it.copy(isSubmitting = false, error = result.message) }
                is ResultState.Loading -> Unit
            }
        }
    }

    fun unassignAdmin() {
        val route = _uiState.value.selectedRoute ?: return
        scope.launch {
            _uiState.update { it.copy(isSubmitting = true, error = null) }
            when (val result = unassignLineAdminUseCase(route.id)) {
                is ResultState.Success -> _uiState.update {
                    it.copy(
                        isSubmitting = false,
                        selectedRoute = result.data,
                        successMessage = "Encargado removido de ${result.data.name}",
                        routes = it.routes.map { r -> if (r.id == result.data.id) result.data else r },
                    )
                }
                is ResultState.Error -> _uiState.update { it.copy(isSubmitting = false, error = result.message) }
                is ResultState.Loading -> Unit
            }
        }
    }

    fun clearError() {
        _uiState.update { it.copy(error = null) }
    }

    fun clearRouteRefreshError() {
        _uiState.update { it.copy(routeRefreshError = null) }
    }

    fun clearSuccess() {
        _uiState.update { it.copy(successMessage = null) }
    }

    fun currentUiState(): LineAdminUiState = _uiState.value

    fun observeUiState(onState: (LineAdminUiState) -> Unit): FlowSubscription {
        val job = scope.launch { uiState.collect { onState(it) } }
        return FlowSubscription { job.cancel() }
    }

    fun clear() = scope.cancel()
}
