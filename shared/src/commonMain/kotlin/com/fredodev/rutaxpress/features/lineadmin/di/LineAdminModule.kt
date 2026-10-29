package com.fredodev.rutaxpress.features.lineadmin.di

import com.fredodev.rutaxpress.features.lineadmin.data.remote.LineAdminApi
import com.fredodev.rutaxpress.features.lineadmin.data.repository.LineAdminRepositoryImpl
import com.fredodev.rutaxpress.features.lineadmin.domain.repository.LineAdminRepository
import com.fredodev.rutaxpress.features.lineadmin.domain.usecase.AssignLineAdminUseCase
import com.fredodev.rutaxpress.features.lineadmin.domain.usecase.ListRoutesUseCase
import com.fredodev.rutaxpress.features.lineadmin.domain.usecase.LookupUserUseCase
import com.fredodev.rutaxpress.features.lineadmin.domain.usecase.UnassignLineAdminUseCase
import com.fredodev.rutaxpress.features.lineadmin.presentation.LineAdminViewModel
import kotlinx.coroutines.CoroutineScope
import org.koin.dsl.module

val lineAdminModule = module {
    single { LineAdminApi(get()) }
    single<LineAdminRepository> { LineAdminRepositoryImpl(get()) }
    single { ListRoutesUseCase(get()) }
    single { LookupUserUseCase(get()) }
    single { AssignLineAdminUseCase(get()) }
    single { UnassignLineAdminUseCase(get()) }
    factory { (scope: CoroutineScope) -> LineAdminViewModel(get(), get(), get(), get(), scope) }
}
