-- Trigger to prevent duplicate bookings
create trigger trg_prevent_duplicate_booking
on municipal.has
instead of insert
as
begin

    if exists (
        select 1
        from inserted i
        join municipal.booking new_booking
            on i.booking_id = new_booking.booking_id
        join municipal.booking existing_booking
            on new_booking.user_id = existing_booking.user_id
        join municipal.has h
            on h.booking_id = existing_booking.booking_id
            and h.session_id = i.session_id
    )

    begin
        throw 51000, 'User already has a booking for this session.', 1;
        return;
    end

    -- If there isn't a duplicate, proceed with the insert
    insert into municipal.has (booking_id, session_id)
    select booking_id, session_id from inserted;

end


-- Trigger to make update balance upon a new payment entity
create trigger municipal.UpdateBalanceOnPayment
on municipal.payment
after insert
as
begin
    set nocount on;

    -- For each user, calculate the sum of all costs
    -- in the inserted batch
    with NewTotals as (
        select
            i.user_id,
            sum(i.cost) as total_cost
        from inserted as i
        group by i.user_id
    )

    -- Check if any user's balance will be negative
    -- after transaction
    if exists (
        select 1
        from NewTotals as nt
        join municipal.app_user as u
            on nt.user_id = u.user_id
        where u.balance + nt.total_cost < 0
    )
    begin
        -- Rollback entire transaction and raise custom error
        rollback transaction;
        throw 51000, 'Transaction would result in negative balance', 1;
        return;
    end;

    -- No negative-balance violations, then update the users
    update u
    set u.balance = u.balance + nt.total_cost
    from municipal.app_user as u
    join NewTotals as nt
        on u.user_id = nt.user_id;
end;