-- File with all the commands to drop EVERYTHING
-- Drop Triggers First
IF OBJECT_ID('municipal.trg_prevent_duplicate_booking', 'TR') IS NOT NULL
    DROP TRIGGER municipal.trg_prevent_duplicate_booking;

IF OBJECT_ID('municipal.UpdateBalanceOnPayment', 'TR') IS NOT NULL
    DROP TRIGGER municipal.UpdateBalanceOnPayment;

-- Drop Stored Procedures
IF OBJECT_ID('municipal.CreateUser', 'P') IS NOT NULL
    DROP PROCEDURE municipal.CreateUser;

IF OBJECT_ID('municipal.CreateInstructor', 'P') IS NOT NULL
    DROP PROCEDURE municipal.CreateInstructor;

IF OBJECT_ID('municipal.CreateLifeguard', 'P') IS NOT NULL
    DROP PROCEDURE municipal.CreateLifeguard;

IF OBJECT_ID('municipal.MakePayment', 'P') IS NOT NULL
    DROP PROCEDURE municipal.MakePayment;

IF OBJECT_ID('municipal.CreateMonitors', 'P') IS NOT NULL
    DROP PROCEDURE municipal.CreateMonitors;

IF OBJECT_ID('municipal.CreateLane', 'P') IS NOT NULL
    DROP PROCEDURE municipal.CreateLane;

IF OBJECT_ID('municipal.createSession', 'P') IS NOT NULL
    DROP PROCEDURE municipal.createSession;

IF OBJECT_ID('municipal.createBooking', 'P') IS NOT NULL
    DROP PROCEDURE municipal.createBooking;

IF OBJECT_ID('municipal.deleteUser', 'P') IS NOT NULL
    DROP PROCEDURE municipal.deleteUser;

-- Drop Functions
-- If SearchSessions is a scalar function (FN), a multi-statement TVF (TF),
-- or an inline TVF (IF), drop it accordingly:
IF OBJECT_ID('municipal.SearchSessions', 'FN') IS NOT NULL
    DROP FUNCTION municipal.SearchSessions;
ELSE IF OBJECT_ID('municipal.SearchSessions', 'TF') IS NOT NULL
    DROP FUNCTION municipal.SearchSessions;
ELSE IF OBJECT_ID('municipal.SearchSessions', 'IF') IS NOT NULL
    DROP FUNCTION municipal.SearchSessions;
GO

-- If PaymentHistory is a scalar function (FN), a multi‐statement TVF (TF),
-- or an inline TVF (IF), drop it accordingly:
IF OBJECT_ID('municipal.PaymentHistory', 'FN') IS NOT NULL
    DROP FUNCTION municipal.PaymentHistory;
ELSE IF OBJECT_ID('municipal.PaymentHistory', 'TF') IS NOT NULL
    DROP FUNCTION municipal.PaymentHistory;
ELSE IF OBJECT_ID('municipal.PaymentHistory', 'IF') IS NOT NULL
    DROP FUNCTION municipal.PaymentHistory;

-- Drop Indexes on Views First
IF EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'UQ_User_session'
    AND object_id = OBJECT_ID('municipal.unique_user_session')
)
    DROP INDEX UQ_User_session ON municipal.unique_user_session;

-- Drop Views
IF OBJECT_ID('municipal.unique_user_session', 'V') IS NOT NULL
    DROP VIEW municipal.unique_user_session;

-- Drop Tables (Reverse Order of Creation)
IF OBJECT_ID('municipal.deletes_has', 'U') IS NOT NULL
    DROP TABLE municipal.deletes_has;

IF OBJECT_ID('municipal.deletes_booking', 'U') IS NOT NULL
    DROP TABLE municipal.deletes_booking;

IF OBJECT_ID('municipal.deletes_payment', 'U') IS NOT NULL
    DROP TABLE municipal.deletes_payment;

IF OBJECT_ID('municipal.deletes_app_user', 'U') IS NOT NULL
    DROP TABLE municipal.deletes_app_user;

IF OBJECT_ID('municipal.has', 'U') IS NOT NULL
    DROP TABLE municipal.has;

IF OBJECT_ID('municipal.booking', 'U') IS NOT NULL
    DROP TABLE municipal.booking;

IF OBJECT_ID('municipal.sessionn', 'U') IS NOT NULL
    DROP TABLE municipal.sessionn;

IF OBJECT_ID('municipal.lane', 'U') IS NOT NULL
    DROP TABLE municipal.lane;

IF OBJECT_ID('municipal.monitors', 'U') IS NOT NULL
    DROP TABLE municipal.monitors;

IF OBJECT_ID('municipal.pool', 'U') IS NOT NULL
    DROP TABLE municipal.pool;

IF OBJECT_ID('municipal.lifeguard', 'U') IS NOT NULL
    DROP TABLE municipal.lifeguard;

IF OBJECT_ID('municipal.instructor', 'U') IS NOT NULL
    DROP TABLE municipal.instructor;

IF OBJECT_ID('municipal.payment', 'U') IS NOT NULL
    DROP TABLE municipal.payment;

IF OBJECT_ID('municipal.app_user', 'U') IS NOT NULL
    DROP TABLE municipal.app_user;

IF OBJECT_ID('municipal.person', 'U') IS NOT NULL
    DROP TABLE municipal.person;

-- Finally, Drop the Schema
IF EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'municipal')
    DROP SCHEMA municipal;