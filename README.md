# Consultas SQL - Gestión de Alojamientos Turísticos

## Motor de base de datos
PostgreSQL 18 

## Esquema de la base de datos
Nombre del esquema: `tourism`

### Tablas principales
- **owners**: propietarios de alojamientos
- **accommodation_types**: tipos de alojamiento (departamento, cabaña, etc.)
- **locations**: ubicaciones geográficas
- **accommodations**: alojamientos publicados
- **rooms**: habitaciones dentro de cada alojamiento
- **amenities** / **accommodation_amenities**: comodidades disponibles
- **guests**: huéspedes registrados
- **bookings**: reservas realizadas
- **booking_statuses**: estados posibles de una reserva
- **booking_guests**: huéspedes adicionales por reserva
- **payments**: pagos asociados a reservas
- **reviews**: reseñas de huéspedes
- **staff_users**: usuarios del staff/administración

## Contenido del repositorio
- `consultas_sql.sql`: 20 consultas SQL (INSERT, SELECT, UPDATE, DELETE, JOIN, agregaciones, subconsultas)
