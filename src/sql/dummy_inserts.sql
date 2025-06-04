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
('321321321', 'Olivia Taylor', 'olivia@example.com', 999001122, '1997-01-19', 26, '909 Redwood Pl'),
('654987321', 'Carlos Silva', 'carlos@example.com', 911223344, '1988-04-12', 36, '1010 Ocean Dr'),
('321654987', 'Elena Rodriguez', 'elena@example.com', 922334455, '1991-09-25', 32, '2020 Bay View'),
('789456123', 'James Wilson', 'jamesw@example.com', 933445566, '1979-03-08', 45, '3030 Harbor St'),
('159753486', 'Sophie Martin', 'sophie@example.com', 944556677, '1994-07-19', 29, '4040 Marina Blvd'),
('486159753', 'Thomas Johnson', 'thomas@example.com', 955667788, '1983-11-30', 40, '5050 Coast Hwy'),
('753159486', 'Liam Anderson', 'liam@example.com', 966778899, '1996-02-14', 28, '6060 Beach Rd'),
('357159486', 'Emma Thompson', 'emmat@example.com', 977889900, '1999-05-27', 25, '7070 Shoreline Dr'),
('258369147', 'Noah Garcia', 'noah@example.com', 988990011, '2001-08-03', 22, '8080 Tidal Way'),
('147258369', 'Olivia Martinez', 'oliviam@example.com', 999001122, '1997-12-11', 26, '9090 Wave St'),
('369147258', 'William Brown', 'william@example.com', 900112233, '1993-06-24', 31, '1010 Surf Ave');


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

(60, '2025-08-01 10:00:00', 'Free', 10, 1, 1, 1),
(45, '2025-08-01 14:00:00', 'Class', 15, NULL, 2, 1),
(60, '2025-08-02 09:00:00', 'Class', 12, 3, 4, 1),
(90, '2025-08-02 16:00:00', 'Aerobics', 8, 2, 5, 1),


(60, '2025-08-01 11:30:00', 'Aerobics', 10, 1, 1, 2),
(45, '2025-08-02 15:00:00', 'Class', 12, 3, 2, 2),


(60, '2025-08-01 08:00:00', 'Free', 10, NULL, 1, 3),
(60, '2025-08-01 18:00:00', 'Aerobics', 8, 1, 3, 3),
(90, '2025-08-02 07:00:00', 'Class', 6, 2, 4, 3),
(45, '2025-08-02 19:00:00', 'Class', 10, 3, 1, 3),


(60, '2025-08-03 07:00:00', 'Aerobics', 12, 4, 1, 1),
(45, '2025-08-03 08:30:00', 'Class', 15, 5, 2, 2),
(90, '2025-08-04 06:30:00', 'Free', 20, NULL, 1, 3),


(60, '2025-08-04 14:00:00', 'Class', 15, 6, 4, 1),
(45, '2025-08-05 15:30:00', 'Aerobics', 10, 7, 3, 2),
(60, '2025-08-06 13:00:00', 'Free', 15, NULL, 2, 3),


(90, '2025-08-05 18:00:00', 'Class', 12, 8, 7, 1),
(60, '2025-08-06 19:30:00', 'Aerobics', 10, 9, 5, 2),
(45, '2025-08-07 17:00:00', 'Free', 15, NULL, 4, 3),


(120, '2025-08-10 09:00:00', 'Class', 20, 4, 1, 1),
(90, '2025-08-10 11:00:00', 'Aerobics', 15, 5, 2, 2),
(60, '2025-08-11 10:30:00', 'Free', 20, NULL, 3, 3),
(90, '2025-08-11 14:00:00', 'Class', 15, 6, 4, 1),
(120, '2025-08-12 15:30:00', 'Aerobics', 12, 7, 5, 2),
(60, '2025-08-12 18:00:00', 'Free', 15, NULL, 1, 3);


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


INSERT INTO municipal.has (booking_id, session_id)
VALUES
    (1,  1),
    (2,  3),
    (4,  2),
    (3,  1),   
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