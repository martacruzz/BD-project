-- people (1 user, 1 lifeguard, 1 instructor)
insert into municipal.person (cc, name, email, phone, date_of_birth, age, address)
values
('123456789', 'John Doe', 'john@example.com', 912345678, '1990-05-14', 35, '123 Main St'),
('987654321', 'Anna Smith', 'anna@example.com', 934567890, '1985-11-23', 39, '456 Side St'),
('456789123', 'Mike Baywatch', 'mike@example.com', 965432187, '1992-07-01', 32, '789 Beach Rd');

-- dummy user
insert into municipal.app_user (person_id, balance, nif, username, password_hash)
values (1, 100, 123456789, 'johndoe', 'hashed_password');

-- dummy instructor
insert into municipal.instructor (person_id, specialization)
values (2, 'Hidroginástica');

-- dummy lifeguard
insert into municipal.lifeguard (person_id)
values (3);

-- dummy pool
insert into municipal.pool (name, location, total_lanes, opening_time, closing_time)
values ('Municipal Pool', 'Downtown', 6, '07:00', '22:00');

-- dummy lanes
insert into municipal.lane (lane_number, status, pool_id)
values
(1, 'available', 1),
(2, 'maintenance', 1);

-- lifeguard to pool
insert into municipal.monitors (pool_id, lifeguard_id)
values (1, 1);

-- dummy session
insert into municipal.sessionn (duration, date_time, sType, max_capacity, instructor_id, lane_number, pool_id)
values (60, '2025-06-01 10:00:00', 'Hidroginástica', 10, 1, 1, 1);

-- dummy booking
insert into municipal.booking (status, booking_date, user_id)
values ('confirmed', '2025-05-28', 1);

-- associate booking with session
insert into municipal.has (booking_id, session_id)
values (1, 1);

-- dummy payment
insert into municipal.payment (cost, user_id)
values (15.00, 1);
