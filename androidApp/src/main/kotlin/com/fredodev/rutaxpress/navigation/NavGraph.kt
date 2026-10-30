package com.fredodev.rutaxpress.navigation

import androidx.compose.runtime.Composable
import androidx.compose.runtime.key
import androidx.compose.runtime.getValue
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.fredodev.rutaxpress.features.auth.LoginScreen
import com.fredodev.rutaxpress.features.auth.domain.repository.AuthRepository
import org.koin.compose.koinInject

sealed class Screen(val route: String) {
    data object Login : Screen("login")
    data object Home : Screen("home")
}

@Composable
fun NavGraph() {
    val navController = rememberNavController()
    val authRepository: AuthRepository = koinInject()
    val session by authRepository.sessionState.collectAsStateWithLifecycle()

    if (session.isRestoring) {
        Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
            CircularProgressIndicator()
        }
    } else {
        key(session.isAuthenticated) {
            NavHost(
                navController = navController,
                startDestination = if (session.isAuthenticated) Screen.Home.route else Screen.Login.route,
            ) {
                composable(Screen.Login.route) {
                    LoginScreen(onLoginSuccess = {})
                }
                composable(Screen.Home.route) {
                    // TODO: HomeScreen()
                }
            }
        }
    }
}
