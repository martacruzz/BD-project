-- Create schema
create schema municipal;
go

-- Create Tables
create table municipal.person (
    cc int primary key,
    name varchar(30),
    email varchar(30),
    phone int,
    date_of_birth date,
    age int,
    address varchar(100)
);

create table municipal.app_user (
    user_id varchar(50) primary key,
    cc int unique not null,
    registration_date date,
    balance int,
    nif int,
    username varchar(30) unique not null,
    password_hash varchar(255) not null,

    foreign key (cc) references municipal.person(cc)
);

create table municipal.payment (
    payment_id varchar(50) primary key,
    cost int,
    user_id varchar(50) unique not null,

    foreign key (user_id) references municipal.app_user(user_id)
);

create table municipal.instructor (
    instructor_id varchar(50) primary key,
    cc int not null,
    specialization varchar(30),

    foreign key (cc) references municipal.person(cc)
);

create table municipal.lifeguard (
    lifeguard_id varchar(50) primary key,
    cc int not null,

    foreign key (cc) references municipal.person(cc)
);

create table municipal.pool (
    pool_id varchar(50) primary key,
    name varchar(30),
    location varchar(100),
    total_lanes int,
    opening_time int,
    closing_time int
);

create table municipal.monitors (
    pool_id varchar(50),
    lifeguard_id varchar(50),

    foreign key (pool_id) references municipal.pool(pool_id),
    foreign key (lifeguard_id) references municipal.lifeguard(lifeguard_id),
    primary key (pool_id, lifeguard_id)
);

create table municipal.lane (
    lane_number int,
    status varchar(30),
    pool_id varchar(50),

    foreign key (pool_id) references municipal.pool(pool_id),
    primary key (pool_id, lane_number)
);

create table municipal.sessionn (
    session_id varchar(50) primary key,
    duration int,
    date_time date,
    sType varchar(30),
    max_capacity int,
    instructor_id varchar(50),
    lane_number int,
    pool_id varchar(50),

    foreign key (instructor_id) references municipal.instructor(instructor_id),
    foreign key (pool_id, lane_number) references municipal.lane(pool_id, lane_number)
);

create table municipal.booking (
    booking_id varchar(50) primary key,
    status varchar(30),
    booking_date date,
    user_id varchar(50),

    foreign key (user_id) references municipal.app_user(user_id)
);

create table municipal.has (
    booking_id varchar(50),
    session_id varchar(50),

    foreign key (booking_id) references municipal.booking(booking_id),
    foreign key (session_id) references municipal.sessionn(session_id),
    primary key (booking_id, session_id)
);

-- dummy insert to check if flask app is working
INSERT INTO municipal.person
VALUES (1, 'Maria Antónia', 'm@ua.pt', 934576809, '2010-01-07', 15, 'Rua do Escuro n47');

-- delete tables
drop table if exists municipal.has;
drop table if exists municipal.booking;
drop table if exists municipal.sessionn;
drop table if exists municipal.lane;
drop table if exists municipal.monitors;
drop table if exists municipal.pool;
drop table if exists municipal.lifeguard;
drop table if exists municipal.instructor;
drop table if exists municipal.payment;
drop table if exists municipal.app_user;
drop table if exists municipal.person;
