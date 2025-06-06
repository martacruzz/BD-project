-- Create schema
create schema municipal;
go

-- Create Tables
create table municipal.person (
    person_id int identity(1,1),
    cc varchar(12),
    name varchar(30),
    email varchar(30),
    phone int,
    date_of_birth date,
    age int,
    address varchar(100),

    primary key (person_id)
);

create table municipal.app_user (
    user_id int identity(1,1),
    person_id int unique not null,
    registration_date timestamp default current_timestamp,
    balance int,
    nif int,
    username varchar(30) unique not null,
    password_hash varchar(255) not null,

    foreign key (person_id) references municipal.person(person_id),
    primary key (user_id)
);

create table municipal.payment (
    payment_id int identity(1,1),
    cost int,
    user_id int not null,

    foreign key (user_id) references municipal.app_user(user_id),
    primary key (payment_id)
);

create table municipal.instructor (
    instructor_id int identity(1,1),
    person_id int not null,
    specialization varchar(30),

    foreign key (person_id) references municipal.person(person_id),
    primary key (instructor_id)
);

create table municipal.lifeguard (
    lifeguard_id int identity(1,1),
    person_id int not null,

    foreign key (person_id) references municipal.person(person_id),
    primary key (lifeguard_id)
);

create table municipal.pool (
    pool_id int identity(1,1),
    name varchar(30),
    location varchar(100),
    total_lanes int,
    opening_time time,
    closing_time time,

    primary key (pool_id)
);

create table municipal.monitors (
    pool_id int,
    lifeguard_id int,

    foreign key (pool_id) references municipal.pool(pool_id),
    foreign key (lifeguard_id) references municipal.lifeguard(lifeguard_id),
    primary key (pool_id, lifeguard_id)
);

create table municipal.lane (
    lane_number int,
    status varchar(30),
    pool_id int,

    foreign key (pool_id) references municipal.pool(pool_id),
    primary key (pool_id, lane_number)
);

create table municipal.sessionn (
    session_id int identity(1,1),
    duration int,
    date_time datetime,
    sType varchar(30),
    max_capacity int,
    instructor_id int,
    lane_number int,
    pool_id int,

    foreign key (instructor_id) references municipal.instructor(instructor_id),
    foreign key (pool_id, lane_number) references municipal.lane(pool_id, lane_number),
    primary key (session_id)
);

create table municipal.booking (
    booking_id int identity(1,1),
    status varchar(30),
    booking_date date,
    user_id int,

    foreign key (user_id) references municipal.app_user(user_id),
    primary key (booking_id)
);

create table municipal.has (
    booking_id int,
    session_id int,

    foreign key (booking_id) references municipal.booking(booking_id),
    foreign key (session_id) references municipal.sessionn(session_id),
    primary key (booking_id, session_id)
);



