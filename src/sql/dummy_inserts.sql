-- People (5 users, 3 instructors, 4 lifeguards)
INSERT INTO municipal.person (cc, name, email, phone, date_of_birth, age, address)
VALUES
('123456789', 'John Doe', 'john@example.com', 912345678, '1990-05-14', 35, '123 Main St'),
('987654321', 'Anna Smith', 'anna@example.com', 934567890, '1985-11-23', 39, '456 Side St'),
('456789123', 'Mike Baywatch', 'mike@example.com', 965432187, '1992-07-01', 32, '789 Beach Rd'),
('112233445', 'Maria Garcia', 'maria@example.com', 911223344, '1998-03-15', 26, '101 Oak Ave'),
('556677889', 'Tom Wilson', 'tom@example.com', 922334455, '2000-08-22', 23, '202 Pine St'),
('998877665', 'Lisa Chen', 'lisa@example.com', 933445566, '1982-12-30', 41, '303 Cedar Blvd'),
('334455667', 'Robert Kim', 'robert@example.com', 944556677, '1975-06-18', 48, '404 Maple Dr'),
('778899001', 'Sophia Brown', 'sophia@example.com', 955667788, '1995-02-09', 28, '505 Birch Ln'),
('123123123', 'David Lee', 'david@example.com', 966778899, '2002-09-05', 21, '606 Elm Ct'),
('456456456', 'Emma Davis', 'emma@example.com', 977889900, '1993-04-25', 30, '707 Spruce Way'),
('789789789', 'James Miller', 'james@example.com', 988990011, '1988-07-12', 35, '808 Fir Rd'),
('321321321', 'Olivia Taylor', 'olivia@example.com', 999001122, '1997-01-19', 26, '909 Redwood Pl');

-- Users (5 users)
INSERT INTO municipal.app_user (person_id, balance, nif, username, password_hash)
VALUES 
(1, 100.00, 123456789, 'johndoe', 'hashed_pw1'),
(4, 50.00, 112233445, 'mariag', 'hashed_pw2'),
(5, 75.00, 556677889, 'tomw', 'hashed_pw3'),
(8, 200.00, 778899001, 'sophiab', 'hashed_pw4'),
(11, 30.00, 789789789, 'jamesm', 'hashed_pw5');

-- Instructors (3 instructors)
INSERT INTO municipal.instructor (person_id, specialization)
VALUES 
(2, 'Hidroginástica'),
(6, 'Natação Adultos'),
(9, 'Aqua Zumba');

-- Lifeguards (4 lifeguards)
INSERT INTO municipal.lifeguard (person_id)
VALUES 
(3),
(7),
(10),
(12);

-- Pools (3 pools)
INSERT INTO municipal.pool (name, location, total_lanes, opening_time, closing_time)
VALUES 
('Piscina Municipal Central', 'Centro Cidade', 8, '07:00', '22:00'),
('Piscina Norte', 'Zona Norte', 6, '08:00', '21:00'),
('Piscina Praia', 'Zona Costeira', 5, '06:00', '20:00');

-- Lanes (18 lanes across 3 pools)
INSERT INTO municipal.lane (lane_number, status, pool_id)
VALUES 
-- Pool 1 (8 lanes)
(1, 'available', 1),
(2, 'available', 1),
(3, 'maintenance', 1),
(4, 'available', 1),
(5, 'available', 1),
(6, 'reserved', 1),
(7, 'available', 1),
(8, 'available', 1),

-- Pool 2 (6 lanes)
(1, 'available', 2),
(2, 'available', 2),
(3, 'available', 2),
(4, 'maintenance', 2),
(5, 'available', 2),
(6, 'available', 2),

-- Pool 3 (5 lanes)
(1, 'available', 3),
(2, 'reserved', 3),
(3, 'available', 3),
(4, 'available', 3),
(5, 'maintenance', 3);

-- Lifeguard assignments
INSERT INTO municipal.monitors (pool_id, lifeguard_id)
VALUES 
(1, 1), (1, 2),  -- Central pool
(2, 3), (2, 4),  -- North pool
(3, 1), (3, 3);  -- Beach pool

-- Sessions (10 sessions across pools)
INSERT INTO municipal.sessionn (duration, date_time, sType, max_capacity, instructor_id, lane_number, pool_id)
VALUES 
-- Pool 1 Sessions
(60, '2025-08-01 10:00:00', 'Free', 10, 1, 1, 1),
(45, '2025-08-01 14:00:00', 'Class', 15, NULL, 2, 1),
(60, '2025-08-02 09:00:00', 'Class', 12, 3, 4, 1),
(90, '2025-08-02 16:00:00', 'Aerobics', 8, 2, 5, 1),

-- Pool 2 Sessions
(60, '2025-08-01 11:30:00', 'Aerobics', 10, 1, 1, 2),
(45, '2025-08-02 15:00:00', 'Class', 12, 3, 2, 2),

-- Pool 3 Sessions
(60, '2025-08-01 08:00:00', 'Free', 10, NULL, 1, 3),
(60, '2025-08-01 18:00:00', 'Aerobics', 8, 1, 3, 3),
(90, '2025-08-02 07:00:00', 'Class', 6, 2, 4, 3),
(45, '2025-08-02 19:00:00', 'Class', 10, 3, 1, 3);

-- Bookings (20 bookings)
INSERT INTO municipal.booking (status, booking_date, user_id)
VALUES 
('confirmed', '2025-05-28', 1),
('confirmed', '2025-05-28', 1),
('confirmed', '2025-05-29', 2),
('confirmed', '2025-05-29', 3),
('confirmed', '2025-05-29', 4),
('confirmed', '2025-05-30', 5),
('confirmed', '2025-05-30', 1),
('confirmed', '2025-05-30', 2),
('confirmed', '2025-05-31', 3),
('confirmed', '2025-05-31', 4),
('confirmed', '2025-05-31', 5),
('confirmed', '2025-05-31', 1),
('waiting', '2025-06-01', 2),
('cancelled', '2025-05-28', 3),
('confirmed', '2025-05-29', 4),
('confirmed', '2025-05-30', 5),
('confirmed', '2025-05-31', 1),
('confirmed', '2025-06-01', 2),
('confirmed', '2025-06-01', 3),
('confirmed', '2025-06-01', 4);

-- Associate bookings with sessions
INSERT INTO municipal.has (booking_id, session_id)
VALUES
    (1,  1),   -- John (user 1) @ Hydro (session 1)
    (2,  3),   -- John (user 1) @ Zumba (session 3)
    (3,  1),   -- Maria (user 2) @ Hydro (session 1)
    (4,  2),   -- Tom (user 3) @ Free Swim (session 2)
    (5,  5),   -- Sophia (user 4) @ Hydro (North) (session 5)
    (6,  7),   -- James (user 5) @ Free Swim (Beach) (session 7)
    (7,  4),   -- John (user 1) @ Comp Swim (session 4)
    (8,  6),   -- Maria (user 2) @ Zumba (North) (session 6)
    (9,  8),   -- Tom (user 3) @ Hydro (Beach) (session 8)
    (10, 9),   -- Sophia (user 4) @ Comp Swim (Beach) (session 9)
    (11, 10),  -- James (user 5) @ Zumba (Beach) (session 10)
    --(12, 4),  -- **REMOVED**: John (user 1) @ session 4 (duplicate of booking 7)
    --(13, 1),  -- **REMOVED**: Maria (user 2) @ session 1 (duplicate of booking 3)
    (14, 3),   -- Tom (user 3) @ Zumba (session 3)
    (15, 2),   -- Sophia (user 4) @ Free Swim (session 2)
    (16, 5),   -- James (user 5) @ Hydro (North) (session 5)
    (17, 7),   -- John (user 1) @ Free Swim (Beach) (session 7)
    (18, 8),   -- Maria (user 2) @ Hydro (Beach) (session 8)
    (19, 9),   -- Tom (user 3) @ Comp Swim (Beach) (session 9)
    (20, 10);  -- Sophia (user 4) @ Zumba (Beach) (session 10)


-- Payments (15 payments)
INSERT INTO municipal.payment (cost, user_id, pay_time)
VALUES 
(-10.00, 1, '2025-05-28 09:15:00'),  -- John payment for session 1
(-5.00, 1, '2025-05-28 14:30:00'),   -- John payment for session 3
(50.00, 1, '2025-05-27 10:00:00'),   -- John top-up
(-10.00, 2, '2025-05-28 10:20:00'),  -- Maria payment
(-8.00, 3, '2025-05-29 08:45:00'),   -- Tom payment
(-12.00, 4, '2025-05-29 09:30:00'),  -- Sophia payment
(-5.00, 5, '2025-05-30 11:15:00'),   -- James payment
(-15.00, 1, '2025-05-30 16:20:00'),  -- John payment for comp swim
(-5.00, 2, '2025-05-30 17:10:00'),   -- Maria payment
(-10.00, 3, '2025-05-31 09:25:00'),  -- Tom payment
(-12.00, 4, '2025-05-31 10:45:00'),  -- Sophia payment
(-5.00, 5, '2025-05-31 12:30:00'),   -- James payment
(30.00, 2, '2025-05-25 14:00:00'),   -- Maria top-up
(20.00, 3, '2025-05-26 15:30:00'),   -- Tom top-up
(-8.00, 4, '2025-06-01 08:05:00');   -- Sophia payment