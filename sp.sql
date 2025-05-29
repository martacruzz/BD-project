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




create procedure municipal.createBooking
    -- Input params
    @status varchar(30),
    @booking_date date,
    @user_id int,

    -- Output param
    @new_booking_id int

as
begin



end;




















