package com.fredodev.rutaxpress.features.lineadmin.data.repository

import com.fredodev.rutaxpress.features.lineadmin.domain.model.Route
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFalse
import kotlin.test.assertNotNull
import kotlin.test.assertNull
import kotlin.test.assertTrue

class RouteCacheTest {
    @Test
    fun cacheExpiresAfterThirtySecondsButKeepsSnapshotForStaleDisplay() {
        var now = 1_000L
        val cache = RouteCache(nowEpochSeconds = { now })
        cache.replace(listOf(route(adminUserId = null)))

        now = 1_029L
        assertTrue(cache.isFresh())

        now = 1_030L
        assertFalse(cache.isFresh())
        assertNotNull(cache.snapshot())
    }

    @Test
    fun successfulAssignmentUpdatesSnapshotWithoutResettingItsAge() {
        var now = 1_000L
        val cache = RouteCache(nowEpochSeconds = { now })
        cache.replace(listOf(route(adminUserId = null)))
        now = 1_010L

        cache.update(route(adminUserId = 9L))
        val snapshot = cache.snapshot()

        assertEquals(1_000L, snapshot?.fetchedAtEpochSeconds)
        assertEquals(9L, snapshot?.routes?.single()?.adminUserId)
        assertTrue(cache.isFresh())
    }

    @Test
    fun updatingMissingSnapshotDoesNotCreatePartialRouteList() {
        val cache = RouteCache(nowEpochSeconds = { 1_000L })

        cache.update(route(adminUserId = 9L))

        assertNull(cache.snapshot())
        assertFalse(cache.isFresh())
    }

    private fun route(adminUserId: Long?) = Route(
        id = 1L,
        name = "Ruta 1",
        code = "R1",
        active = true,
        adminUserId = adminUserId,
    )
}
