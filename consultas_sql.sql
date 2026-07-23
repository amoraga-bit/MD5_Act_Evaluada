-- ========================================
-- 01. INSERT - Insertar propietario
-- ========================================
INSERT INTO tourism.owners (first_name, last_name, company_name, email, phone, tax_id, address_line1, city, state, country, postal_code)
VALUES ('Carlos', 'Mendoza', 'Mendoza Hospedajes S.A.', 'carlos.mendoza@example.com', '+54911234567', 'TAX12345', 'Av. Libertador 1200', 'Buenos Aires', 'Buenos Aires', 'Argentina', '1425')
RETURNING owner_id;

-- ========================================
-- 02. INSERT - Insertar alojamiento vinculado
-- ========================================
INSERT INTO tourism.accommodations (owner_id, accommodation_type_id, location_id, name, description, max_guests, bedroom_count, bathroom_count, base_price_per_night, currency_code, check_in_time, check_out_time, is_active)
VALUES (1, 1, 1, 'Departamento Vista al Mar', 'Departamento moderno con vista al mar', 4, 2, 1, 85000.00, 'ARS', '14:00', '10:00', true)
RETURNING accommodation_id;

-- ========================================
-- 03. INSERT - Huésped y reserva (CTE encadenado)
-- ========================================
WITH nuevo_huesped AS (
  INSERT INTO tourism.guests (first_name, last_name, email, phone, date_of_birth, nationality, passport_number)
  VALUES ('Lucía', 'Fernández', 'lucia.fernandez@example.com', '+5491155556666', '1990-05-14', 'Argentina', 'AR1234567')
  RETURNING guest_id
)
INSERT INTO tourism.bookings (guest_id, accommodation_id, room_id, booking_status_id, check_in_date, check_out_date, adult_count, child_count, subtotal_amount, tax_amount, discount_amount, total_amount, booking_reference)
SELECT guest_id, 1, 1, 1, '2026-08-10', '2026-08-15', 2, 0, 425000.00, 42500.00, 0, 467500.00, 'BK-0001'
FROM nuevo_huesped
RETURNING booking_id;

-- ========================================
-- 04. INSERT - Insertar pago
-- ========================================
INSERT INTO tourism.payments (booking_id, payment_date, amount, payment_method, payment_status, transaction_reference)
VALUES (1, now(), 467500.00, 'Tarjeta de crédito', 'Completado', 'TXN-000123');

-- ========================================
-- 05. SELECT - Alojamientos activos
-- ========================================
SELECT accommodation_id, name, base_price_per_night, currency_code
FROM tourism.accommodations
WHERE is_active = true;

-- ========================================
-- 06. SELECT - Huéspedes por nacionalidad
-- ========================================
SELECT guest_id, first_name, last_name, nationality
FROM tourism.guests
WHERE nationality = 'Argentina';


-- ========================================
-- 06. SELECT - Huéspedes por nacionalidad. Este lo repetí de 
-- esta otra forma porque no me quedo claro si era un listado 
-- ordenado de huespedes por nacionalidad o el total por 
-- nacionalidad
-- ========================================
SELECT nationality, COUNT(*) AS total_huespedes
FROM tourism.guests
GROUP BY nationality
ORDER BY total_huespedes DESC;


-- ========================================
-- 07. SELECT - Reservas por rango de fechas
-- ========================================
SELECT booking_id, guest_id, check_in_date, check_out_date
FROM tourism.bookings
WHERE check_in_date BETWEEN '2026-08-01' AND '2026-08-31';

-- ========================================
-- 08. UPDATE - Actualizar precio de alojamiento
-- ========================================
UPDATE tourism.accommodations
SET base_price_per_night = 90000.00,
    updated_at = now()
WHERE accommodation_id = 1;

-- ========================================
-- 09. UPDATE - Actualizar estado de reserva
-- ========================================
UPDATE tourism.bookings
SET booking_status_id = 2,
    updated_at = now()
WHERE booking_id = 1;

-- ========================================
-- 10. DELETE - Eliminar reseña
-- ========================================
DELETE FROM tourism.reviews
WHERE review_id = 5;

-- ========================================
-- 11. JOIN - Reservas + huésped
-- ========================================
SELECT b.booking_id, b.check_in_date, b.check_out_date, g.first_name, g.last_name
FROM tourism.bookings b
INNER JOIN tourism.guests g ON b.guest_id = g.guest_id;

-- ========================================
-- 12. JOIN múltiple - Alojamiento completo
-- ========================================
SELECT a.accommodation_id, a.name, o.first_name AS propietario, l.city, l.country, t.type_name
FROM tourism.accommodations a
INNER JOIN tourism.owners o ON a.owner_id = o.owner_id
INNER JOIN tourism.locations l ON a.location_id = l.location_id
INNER JOIN tourism.accommodation_types t ON a.accommodation_type_id = t.accommodation_type_id;

-- ========================================
-- 13. JOIN combinado - Pagos + reservas
-- ========================================
SELECT p.payment_id, p.amount, p.payment_status, b.booking_reference, b.check_in_date
FROM tourism.payments p
INNER JOIN tourism.bookings b ON p.booking_id = b.booking_id;

-- ========================================
-- 14. LEFT JOIN - Alojamientos sin reseñas
-- ========================================
SELECT a.accommodation_id, a.name, r.review_id
FROM tourism.accommodations a
LEFT JOIN tourism.reviews r ON a.accommodation_id = r.accommodation_id
WHERE r.review_id IS NULL;

-- ========================================
-- 15. LEFT JOIN - Alojamientos sin reservas
-- ========================================
SELECT a.accommodation_id, a.name, b.booking_id
FROM tourism.accommodations a
LEFT JOIN tourism.bookings b ON a.accommodation_id = b.accommodation_id
WHERE b.booking_id IS NULL;

-- ========================================
-- 16. AGG - Total de ingresos (SUM)
-- ========================================
SELECT SUM(amount) AS total_ingresos
FROM tourism.payments
WHERE payment_status = 'Completado';

-- ========================================
-- 17. AGG - Promedio de rating por alojamiento (AVG)
-- ========================================
SELECT accommodation_id, AVG(rating) AS promedio_rating
FROM tourism.reviews
GROUP BY accommodation_id;

-- ========================================
-- 18. AGG - Top alojamientos por reservas (COUNT + LIMIT)
-- ========================================
SELECT accommodation_id, COUNT(booking_id) AS total_reservas
FROM tourism.bookings
GROUP BY accommodation_id
ORDER BY total_reservas DESC
LIMIT 5;

-- ========================================
-- 19. HAVING - Alojamientos con más de 3 reservas
-- ========================================
SELECT accommodation_id, COUNT(booking_id) AS total_reservas
FROM tourism.bookings
GROUP BY accommodation_id
HAVING COUNT(booking_id) > 3;

-- ========================================
-- 20. Subconsulta - Alojamiento más caro
-- ========================================
SELECT accommodation_id, name, base_price_per_night
FROM tourism.accommodations
WHERE base_price_per_night = (
  SELECT MAX(base_price_per_night) FROM tourism.accommodations
);