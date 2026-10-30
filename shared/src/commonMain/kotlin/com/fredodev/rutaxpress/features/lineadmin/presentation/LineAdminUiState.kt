package com.fredodev.rutaxpress.features.lineadmin.presentation

import com.fredodev.rutaxpress.features.lineadmin.domain.model.Route
import com.fredodev.rutaxpress.features.lineadmin.domain.model.UserSummary

data class LineAdminUiState(
    val isLoadingRoutes: Boolean = false,
    val isRefreshingRoutes: Boolean = false,
    val routeRefreshError: String? = null,
    val routes: List<Route> = emptyList(),
    val selectedRoute: Route? = null,
    val isLookingUpUser: Boolean = false,
    val foundUser: UserSummary? = null,
    val isSubmitting: Boolean = false,
    val successMessage: String? = null,
    val error: String? = null,
)
