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

INSERT INTO municipal.app_user (person_id, balance, nif, username, password_hash)
VALUES 
(1, 100.00, 123456789, 'johndoe', 'hashed_pw1'),
(4, 50.00, 112233445, 'mariag', 'hashed_pw2'),
(5, 75.00, 556677889, 'tomw', 'hashed_pw3'),
(8, 200.00, 778899001, 'sophiab', 'hashed_pw4'),
(11, 30.00, 789789789, 'jamesm', 'hashed_pw5');

INSERT INTO municipal.instructor (person_id, specialization)
VALUES 
(2, 'Hidroginástica'),
(6, 'Natação Adultos'),
(9, 'Aqua Zumba');

INSERT INTO municipal.lifeguard (person_id)
VALUES 
(3),
(7),
(10),
(12);

INSERT INTO municipal.pool (name, location, total_lanes, opening_time, closing_time)
VALUES 
('Piscina Municipal Central', 'Centro Cidade', 8, '07:00', '22:00'),
('Piscina Norte', 'Zona Norte', 6, '08:00', '21:00'),
('Piscina Praia', 'Zona Costeira', 5, '06:00', '20:00');

INSERT INTO municipal.lane (lane_number, status, pool_id)
VALUES 

(1, 'available', 1),
(2, 'available', 1),
(3, 'maintenance', 1),
(4, 'available', 1),
(5, 'available', 1),
(6, 'reserved', 1),
(7, 'available', 1),
(8, 'available', 1),

(1, 'available', 2),
(2, 'available', 2),
(3, 'available', 2),
(4, 'maintenance', 2),
(5, 'available', 2),
(6, 'available', 2),

(1, 'available', 3),
(2, 'reserved', 3),
(3, 'available', 3),
(4, 'available', 3),
(5, 'maintenance', 3);

INSERT INTO municipal.monitors (pool_id, lifeguard_id)
VALUES 
(1, 1), (1, 2),
(2, 3), (2, 4),
(3, 1), (3, 3);

INSERT INTO municipal.sessionn (duration, date_time, sType, max_capacity, instructor_id, lane_number, pool_id)
VALUES 
(60, '2025-08-28 10:00:00', 'Free', 10, 1, 1, 1),
(45, '2025-08-28 14:00:00', 'Class', 15, 1, 2, 1),
(60, '2025-08-29 09:00:00', 'Class', 12, 3, 4, 1),
(90, '2025-08-29 16:00:00', 'Aerobics', 8, 2, 5, 1),

(60, '2025-08-28 11:30:00', 'Aerobics', 10, 1, 1, 2),
(45, '2025-08-29 15:00:00', 'Class', 12, 3, 2, 2),

(60, '2025-08-28 08:00:00', 'Free', 10, 1, 1, 3),
(60, '2025-08-28 18:00:00', 'Aerobics', 8, 1, 3, 3),
(90, '2025-08-29 07:00:00', 'Class', 6, 2, 4, 3),
(45, '2025-08-29 19:00:00', 'Class', 10, 3, 1, 3);


INSERT INTO municipal.booking (status, booking_date, user_id)
VALUES 
('confirmed', '2025-08-26', 1),
('confirmed', '2025-08-26', 1),
('confirmed', '2025-08-27', 2),
('confirmed', '2025-08-27', 3),
('confirmed', '2025-08-27', 4),
('confirmed', '2025-08-28', 5),
('confirmed', '2025-08-28', 1),
('confirmed', '2025-08-28', 2),
('confirmed', '2025-08-29', 3),
('confirmed', '2025-08-29', 4),
('confirmed', '2025-08-29', 5),
('confirmed', '2025-08-29', 1),
('waiting', '2025-08-26', 2),
('cancelled', '2025-08-26', 3),
('confirmed', '2025-08-27', 4),
('confirmed', '2025-08-28', 5),
('confirmed', '2025-08-29', 1),
('confirmed', '2025-08-26', 2),
('confirmed', '2025-08-26', 3),
('confirmed', '2025-08-26', 4);


-- Associate bookings with sessions
INSERT INTO municipal.has (booking_id, session_id)
VALUES
    (1,  1),
    (2,  3),
    (3,  1),
    (4,  2),
    (5,  5),
    (6,  7),
    (7,  4),
    (8,  6),
    (9,  8),
    (10, 9),
    (11, 10),
    (14, 3),
    (15, 2),
    (16, 5),
    (17, 7),
    (18, 8),
    (19, 9),
    (20, 10);



INSERT INTO municipal.payment (cost, user_id, pay_time)
VALUES 
(-10.00, 1, '2025-05-28 09:15:00'),
(-5.00, 1, '2025-05-28 14:30:00'),
(50.00, 1, '2025-05-27 10:00:00'),
(-10.00, 2, '2025-05-28 10:20:00'),
(-8.00, 3, '2025-05-29 08:45:00'),
(-12.00, 4, '2025-05-29 09:30:00'),
(-5.00, 5, '2025-05-30 11:15:00'),
(-15.00, 1, '2025-05-30 16:20:00'),
(-5.00, 2, '2025-05-30 17:10:00'),
(-10.00, 3, '2025-05-31 09:25:00'),
(-12.00, 4, '2025-05-31 10:45:00'),
(-5.00, 5, '2025-05-31 12:30:00'),
(30.00, 2, '2025-05-25 14:00:00'),
(20.00, 3, '2025-05-26 15:30:00'),
(-8.00, 4, '2025-06-01 08:05:00');