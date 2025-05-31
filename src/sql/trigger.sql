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