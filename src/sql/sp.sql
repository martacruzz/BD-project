-- Add a normal user
create procedure municipal.CreateUser
    -- Person parameters
    @cc varchar(12),
    @name varchar(30),
    @email varchar(30),
    @phone int,
    @date_of_birth date,
    @address varchar(100),

    -- User parameters
    @nif int,
    @username varchar(30),
    @password_hash varchar(255),

    -- Output
    @new_person_id int output,
    @new_user_id int output

as
begin

    set nocount on; -- Betters performance by deactivating unnecessary messages

    begin try
        begin transaction;

        -- 1. Insert into person table
        insert into municipal.person (
            cc,
            name,
            email,
            phone,
            date_of_birth,
            address
        )
        values (
            @cc,
            @name,
            @email,
            @phone,
            @date_of_birth,
            @address
        );

        set @new_person_id = scope_identity();

        -- 2. Insert into user
        insert into municipal.app_user (
            person_id,
            balance,
            nif,
            username,
            password_hash
        )
        values (
            @new_person_id,
            0,  -- Default value will be 0 to start
            @nif,
            @username,
            @password_hash
        );

        set @new_user_id = scope_identity();

        commit transaction;
    end try
    begin catch
        if @@trancount > 0
            rollback transaction;

        -- Handle specific errors
        declare @errorMessage nvarchar(4000) = error_message();
        declare @errorSeverity int = error_severity();
        declare @errorState int = error_state();

        if error_number() = 2627 -- Means the error is a unique violation
        begin
            if charindex('UQ_cc', @errorMessage) > 0
                raiserror('CC number already exists', 16, 1);
            else if charindex('UQ_username', @errorMessage) > 0
                raiserror('Username already taken', 16, 1);
            else
                raiserror(@errorMessage, @errorSeverity, @errorState);
        end
        else
        begin
            raiserror(@errorMessage, @errorSeverity, @errorState);
        end
    end catch
end;




-- Add a intructor
create procedure municipal.CreateInstructor
    -- Person parameters
    @cc varchar(12),
    @name varchar(30),
    @email varchar(30),
    @phone int,
    @date_of_birth date,
    @address varchar(100),

    -- Instructor parameters
    @specialization varchar(30),

    -- Output
    @new_person_id int output,
    @new_instructor_id int output

as
begin

    set nocount on; -- Betters performance by deactivating unnecessary messages

    begin try
        begin transaction;

        -- 1. Insert into person table
        insert into municipal.person (
            cc,
            name,
            email,
            phone,
            date_of_birth,
            address
        )
        values (
            @cc,
            @name,
            @email,
            @phone,
            @date_of_birth,
            @address
        );

        set @new_person_id = scope_identity();

        -- 2. Insert into user
        insert into municipal.instructor (
            person_id,
            specialization
        )
        values (
            @new_person_id,
            @specialization
        );

        set @new_instructor_id = scope_identity();

        commit transaction;
    end try
    begin catch
        if @@trancount > 0
            rollback transaction;

        -- Handle specific errors
        declare @errorMessage nvarchar(4000) = error_message();
        declare @errorSeverity int = error_severity();
        declare @errorState int = error_state();
        raiserror(@errorMessage, @errorSeverity, @errorState);

    end catch
end;



-- Add a Lifeguard
create procedure municipal.CreateLifeguard
    -- Person parameters
    @cc varchar(12),
    @name varchar(30),
    @email varchar(30),
    @phone int,
    @date_of_birth date,
    @address varchar(100),

    -- Lifeguard parameters

    -- Output
    @new_person_id int output,
    @new_lifeguard_id int output

as
begin

    set nocount on; -- Betters performance by deactivating unnecessary messages

    begin try
        begin transaction;

        -- 1. Insert into person table
        insert into municipal.person (
            cc,
            name,
            email,
            phone,
            date_of_birth,
            address
        )
        values (
            @cc,
            @name,
            @email,
            @phone,
            @date_of_birth,
            @address
        );

        set @new_person_id = scope_identity();

        -- 2. Insert into user
        insert into municipal.lifeguard (
            person_id
        )
        values (
            @new_person_id
        );

        set @new_lifeguard_id = scope_identity();

        commit transaction;
    end try
    begin catch
        if @@trancount > 0
            rollback transaction;

        -- Handle specific errors
        declare @errorMessage nvarchar(4000) = error_message();
        declare @errorSeverity int = error_severity();
        declare @errorState int = error_state();
        raiserror(@errorMessage, @errorSeverity, @errorState);

    end catch
end;



-- Make payment method
create procedure municipal.MakePayment
    -- Payment parameters
    @cost decimal(10, 2),
    @user_id int,

    -- Output parameters
    @new_payment_id int output

as
begin

    set nocount on;

    begin try
        begin transaction;

        -- 1. Insert into payment table
        insert into municipal.payment (
            cost,
            user_id
        )
        values (
            @cost,
            @user_id
        );

        set @new_payment_id = scope_identity();

        commit transaction;
    end try
    begin catch
        if @@trancount > 0
            rollback transaction;

        -- Handle errors generically
        declare @errorMessage nvarchar(4000) = error_message();
        declare @errorSeverity int = error_severity();
        declare @errorState int = error_state();
        raiserror(@errorMessage, @errorSeverity, @errorState);

    end catch
end;




create procedure municipal.CreateMonitors
    -- Input parameters
    @pool_id int,
    @lifeguard_id int

as
begin

    set nocount on;

    begin try
        begin transaction

            -- Insert into monitors table
            insert into municipal.monitors (
                pool_id,
                lifeguard_id
            )
            values (
                @pool_id,
                @lifeguard_id
            );

        commit transaction;
    end try
    begin catch
        if @@trancount > 0
            rollback transaction;

        -- Handle errors generically
        declare @errorMessage nvarchar(4000) = error_message();
        declare @errorSeverity int = error_severity();
        declare @errorState int = error_state();
        raiserror(@errorMessage, @errorSeverity, @errorState);

    end catch

end;



create procedure municipal.CreateLane
    -- Input parameter
    @lane_number int,
    @status varchar(30),
    @pool_id int

as
begin

    set nocount on;

    begin try
        begin transaction

            insert into municipal.lane (
                lane_number,
                status,
                pool_id
            )
            values (
                @lane_number,
                @status,
                @pool_id
            );

        commit transaction;
    end try
    begin catch
        if @@trancount > 0
            rollback transaction;

        -- Handle errors generically
        declare @errorMessage nvarchar(4000) = error_message();
        declare @errorSeverity int = error_severity();
        declare @errorState int = error_state();
        raiserror(@errorMessage, @errorSeverity, @errorState);

    end catch

end;



create procedure municipal.createSession
    -- Input params
    @duration int,
    @date_time datetime,
    @sType varchar(30),
    @max_capacity int,
    @instructor_id int,
    @lane_number int,
    @pool_id int,

    -- Output param
    @new_session_id int

as
begin

    set nocount on;

    begin try
        begin transaction

            -- Insert values into session table
            insert into (
                duration,
                date_time,
                sType,
                max_capacity,
                instructor_id,
                lane_number,
                pool_id
            )
            values (
                @duration,
                @date_time,
                @sType,
                @max_capacity,
                @instructor_id,
                @lane_number,
                @pool_id
            );

            set @new_session_id = scope_identity();

        commit transaction;
    end try
    begin catch
        if @@trancount > 0
            rollback transaction;

        -- Handle errors generically
        declare @errorMessage nvarchar(4000) = error_message();
        declare @errorSeverity int = error_severity();
        declare @errorState int = error_state();
        raiserror(@errorMessage, @errorSeverity, @errorState);

    end catch

end;



-- Create a booking
create procedure municipal.createBooking
    -- Input params
    @user_id int,
    @session_id int
as
begin
    set nocount on;
    begin try
        begin transaction;

        -- Set high isolation level to prevent concurrency issues
        set transaction isolation level serializable;

        -- 1. Validate that session exists
        if not exists (
            select 1
            from municipal.sessionn
            where session_id = @session_id
        )
        begin
            rollback;
            return 1; -- Session not found
        end;

        -- 2. Check session capacity
        declare @max_capacity int, @current_bookings int;

        select @max_capacity = max_capacity
        from municipal.sessionn
        where session_id = @session_id;

        select @current_bookings = count(*)
        from municipal.has h
        join municipal.booking b on h.booking_id = b.booking_id
        where h.session_id = @session_id;

        if @current_bookings >= @max_capacity
        begin
            rollback;
            return 2; -- Session full
        end;

        -- 3. Check for existing booking
        if exists (
            select 1
            from municipal.unique_user_session
            where user_id = @user_id and session_id = @session_id
        )
        begin
            rollback;
            return 3; -- Duplicate booking
        end;

        -- 4. Create booking
        declare @booking_id int;

        insert into municipal.booking (status, booking_date, user_id)
        values ('confirmed', cast(getdate() as date), @user_id)

        set @booking_id = scope_identity();

        -- 5. Link booking to session
        insert into municipal.has (booking_id, session_id)
        values (@booking_id, @session_id);

        commit transaction;
        return 0; -- SUccess
    end try
    begin catch
        if @@trancount > 0
            rollback transaction;
        
        -- Handle other errors (those that weren't already)
        return 4; -- Unexpected
    end catch;

end;
go




create procedure municipal.deleteUser
    -- Input params
    @user_id int

as
begin

    set nocount on;
    begin try
        begin transaction;

        -- Get the person_id of the user
        declare @person_id int;
        select @person_id = person_id
        from municipal.app_user
        where user_id = @user_id;

        -- Exit if the user doesn't exist
        if @person_id is null
        begin
            return;
        end;

        -- Backup and Delete from the junction tables (has) through booking
        insert into municipal.deletes_has (booking_id, session_id, deleted_at)
        select booking_id, session_id, current_timestamp
        from municipal.has
        where booking_id in (
            select booking_id
            from municipal.booking
            where user_id = @user_id
        );

        delete from municipal.has
        where booking_id in (
            select booking_id
            from municipal.booking
            where user_id = @user_id
        );

        -- Backup and Delete user's bookings
        insert into municipal.deletes_booking (booking_id, status, booking_date, user_id, deleted_at)
        select booking_id, status, booking_date, user_id, current_timestamp
        from municipal.booking
        where user_id = @user_id;

        delete from municipal.booking
        where user_id = @user_id;

        -- Backup and Delete user's payments
        insert into municipal.deletes_payment (payment_id, cost, user_id, deleted_at)
        select payment_id, cost, user_id, current_timestamp
        from municipal.payment
        where user_id = @user_id;

        delete from municipal.payment
        where user_id = @user_id;

        -- Backup and Delete the user record
        insert into municipal.deletes_app_user (user_id, person_id, registration_date, balance, nif, username, password_hash, deleted_at)
        select user_id, person_id, registration_date, balance, nif, username, password_hash, current_timestamp
        from municipal.app_user
        where user_id = @user_id;

        delete from municipal.app_user
        where user_id = @user_id;

        -- We don't delete the person, 
        -- because he might want to continue being a lifeguard or intructor


        commit transaction;
    end try
    begin catch
        if @trancount > 0
            rollback transaction
        throw;
    end catch;

end;
go















