-- Search session based on many different parameters
create function municipal.SearchSessions (
    @sType varchar(30) = null,
    @instructor_name varchar(30) = null,
    @duration_min int = null,
    @duration_max int = null,
    @search_date date = null
)
returns table
as
return (
    select
        s.session_id,
        s.duration,
        s.date_time,
        s.sType,
        s.max_capacity,
        i.instructor_id,
        p.name as instructor_name,
        s.lane_number,
        po.pool_id,
        po.name as pool_name,
        l.status as lane_status
    from municipal.sessionn s
    left join municipal.instructor i as s.instructor_id = i.instructor_id
    left join municipal.person p on i.person_id = p.person_id
    join municipal.lane l on s.pool_id = l.pool_id ans s.lane_number = l.lane_number
    join municipal.pool po on s.pool_id = po.pool_id
    where
        (@sType is null or s.sType = @sType) -- Apply filters if they exist
        and (@instructor_name is null or p.name like '%' + @instructor_name + '%')
        and (
            (@duration_min is null and @duration_max is null) or
            (s.duration between coalesce(@duration_min, 0) and coalesce(@duration_max, 2147483647))
        )
        and (@search_date is null or cast(s.data_time as date) = @search_date)
);



-- Payment history
create function municipal.PaymentHistory (
    @user_id int
)
returns table
as
return (
    select
        payment_id,
        cost,
        pay_time
    from municipal.payment
    where user_id = @user_id
);