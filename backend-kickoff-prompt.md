# Prompt inicial — Backend RutaXpress

Copia y pega esto en tu sesión de Claude para el backend:

---

Estoy construyendo el backend de **RutaXpress**, app móvil (Kotlin Multiplatform: Android + iOS) de transporte público para Cochabamba, Bolivia. Proyecto de grado. El frontend (KMM) ya existe y está avanzado con UI estática/mock; ahora necesito el backend real para conectarlo.

## Qué resuelve la app
Los "trufis" (transporte público informal) no tienen geolocalización en tiempo real. Los usuarios no saben si un trufi de su línea está cerca, disponible o lleno. La app muestra en un mapa la ubicación en vivo de los trufis, paradas cercanas, y notifica al usuario cuándo salir.

## Stack obligatorio
- **Spring Boot** (Kotlin o Java, como ya esté el proyecto existente)
- **PostgreSQL + PostGIS** para datos geoespaciales (ubicaciones, rutas, paradas, cálculo de cercanía)
- **WebSocket** (STOMP sobre SockJS o WS plano) para transmitir la ubicación de los trufis en tiempo real a los clientes suscritos
- **Swagger/OpenAPI** para documentar los endpoints

## Backend YA existe parcialmente — no lo rompas
Ya hay un backend desplegado en `https://rutaxpressapi.onrender.com/api/users` con:
- `POST /api/users/login` → body `{identifier, password}` → responde `{id, name, username, email, message}`
- `POST /api/users/register` → body `{name, username, email, password}` → responde `{id, name, username, email, message}`

**Ojo:** el login actual NO devuelve token — hay que agregar JWT (o sesión) sin romper esos campos que ya consume el cliente KMM (`shared/.../features/auth/data/remote/AuthApi.kt`, `LoginRequestDto.kt`). Cualquier cambio a esos contratos hay que coordinarlo, porque el cliente ya está hecho.

## Entidades del dominio (del anteproyecto)
- **Usuario** (pasajero) — ya existe parcialmente
- **Conductor**
- **Vehículo** (trufi): línea, placa, capacidad, conductor asignado
- **Ruta**: línea, recorrido (geometría PostGIS `LINESTRING`), paradas asociadas
- **Parada**: ubicación (PostGIS `POINT`), rutas que pasan
- **Ubicación**: posición en tiempo real de cada vehículo (lat/lng, timestamp) — esto es lo que va por WebSocket
- **EstadoVehiculo**: disponible / lleno / fuera de servicio / en pausa
- **Notificación**: alertas al usuario (trufi cerca, demora, etc.)
- **Reporte**: estadísticas de uso, rutas más demandadas, tiempos promedio (para administradores)

## Lo que necesito que me ayudes a diseñar primero (no a codear todavía)
1. Esquema de base de datos (tablas + columnas PostGIS) para las entidades de arriba.
2. Contrato REST completo (endpoints, request/response) para: rutas, paradas, vehículos, estado de vehículo, notificaciones, reportes — coherente con el login/register que ya existe.
3. Contrato del canal WebSocket para ubicación en tiempo real: cómo se suscribe el cliente (¿por ruta? ¿por zona geográfica?), formato del mensaje, frecuencia esperada.
4. Estrategia de autenticación (JWT) que agregue token sin romper los campos actuales de login/register.

Todo esto alimenta una app KMM (Android + iOS) ya construida en el frontend — el mapa, las paradas, el estado del trufi y las alertas del cliente ya tienen UI lista esperando datos reales.

---

*(Fin del prompt — pégalo tal cual en tu sesión de backend)*
