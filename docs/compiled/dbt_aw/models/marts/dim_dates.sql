with
    raw_dates as (
        
    
    with
        base_dates as (
    with
        date_spine as (

            

    
    with
        rawdata as (

            

    

    with
        p as (
            select 0 as generated_number
            union all
            select 1
        ),
        unioned as (

            select

                
                    p0.generated_number * power(2, 0)
                     + 
                
                    p1.generated_number * power(2, 1)
                     + 
                
                    p2.generated_number * power(2, 2)
                     + 
                
                    p3.generated_number * power(2, 3)
                     + 
                
                    p4.generated_number * power(2, 4)
                     + 
                
                    p5.generated_number * power(2, 5)
                     + 
                
                    p6.generated_number * power(2, 6)
                     + 
                
                    p7.generated_number * power(2, 7)
                     + 
                
                    p8.generated_number * power(2, 8)
                     + 
                
                    p9.generated_number * power(2, 9)
                     + 
                
                    p10.generated_number * power(2, 10)
                     + 
                
                    p11.generated_number * power(2, 11)
                     + 
                
                    p12.generated_number * power(2, 12)
                    
                
                + 1 as generated_number

            from

            
                    p as p0  cross join 
            
                    p as p1  cross join 
            
                    p as p2  cross join 
            
                    p as p3  cross join 
            
                    p as p4  cross join 
            
                    p as p5  cross join 
            
                    p as p6  cross join 
            
                    p as p7  cross join 
            
                    p as p8  cross join 
            
                    p as p9  cross join 
            
                    p as p10  cross join 
            
                    p as p11  cross join 
            
                    p as p12 
            

        )

    select *
    from unioned
    where generated_number <= 5477
    order by generated_number



        ),

        all_periods as (

            select
                (
                    timestampadd(day, (row_number() over (order by 1) - 1), cast('2005-01-01' as timestamp))
                ) as date_day
            from rawdata

        ),

        filtered as (

            select * from all_periods where date_day <= cast('2019-12-31' as timestamp)

        )

    select *
    from filtered



        )
    select
        cast(d.date_day as timestamp) as date_day
    from date_spine d

),
        dates_with_prior_year_dates as (

            select
                cast(d.date_day as date) as date_day,
                cast(
                    timestampadd(year, -1, d.date_day) as date
                ) as prior_year_date_day,
                cast(
                    timestampadd(day, -364, d.date_day) as date
                ) as prior_year_over_year_date_day
            from base_dates d

        )
    select
        d.date_day,
        cast(timestampadd(day, -1, d.date_day) as date) as prior_date_day,
        cast(timestampadd(day, 1, d.date_day) as date) as next_date_day,
        d.prior_year_date_day as prior_year_date_day,
        d.prior_year_over_year_date_day,
        date_part('dayofweek', d.date_day) as day_of_week,
        date_part('dayofweek_iso', d.date_day) as day_of_week_iso,
        date_format(d.date_day, 'EEEE') as day_of_week_name,
        date_format(d.date_day, 'E') as day_of_week_name_short,
        date_part('day', d.date_day) as day_of_month,
        dayofyear(d.date_day) as day_of_year,

        cast(date_trunc('week', d.date_day) as date) as week_start_date,
        cast(
        timestampadd(day, -1, timestampadd(week, 1, date_trunc('week', d.date_day)))
        as date) as week_end_date,
        cast(date_trunc('week', d.prior_year_over_year_date_day) as date)
        as prior_year_week_start_date,
        cast(
        timestampadd(day, -1, timestampadd(week, 1, date_trunc('week', d.prior_year_over_year_date_day)))
        as date)
        as prior_year_week_end_date,
        cast(date_part('week', d.date_day) as integer) as week_of_year,

        cast(date_trunc('week', d.date_day) as date) as iso_week_start_date,
        cast(timestampadd(day, 6, cast(date_trunc('week', d.date_day) as date)) as date) as iso_week_end_date,
        cast(date_trunc('week', d.prior_year_over_year_date_day) as date)
        as prior_year_iso_week_start_date,
        cast(timestampadd(day, 6, cast(date_trunc('week', d.prior_year_over_year_date_day) as date)) as date)
        as prior_year_iso_week_end_date,
        cast(date_part('week', d.date_day) as integer) as iso_week_of_year,
        case
        when cast(date_part('week', d.date_day) as integer) = 1
        then
            concat(
                date_part('year', cast(timestampadd(day, 6, cast(date_trunc('week', d.date_day) as date)) as date)),
                '-W',
                lpad(concat('',cast(date_part('week', d.date_day) as integer)), 2, '0')
            )
        else
            concat(
                date_part('year', cast(date_trunc('week', d.date_day) as date)),
                '-W',
                lpad(concat('', cast(date_part('week', d.date_day) as integer)), 2, '0')
            )
    end as iso_year_week,

        cast(date_part('week', d.prior_year_over_year_date_day) as integer)
        as prior_year_week_of_year,
        cast(date_part('week', d.prior_year_over_year_date_day) as integer)
        as prior_year_iso_week_of_year,

        cast(
            date_part('month', d.date_day) as integer
        ) as month_of_year,
        date_format(d.date_day, 'MMMM') as month_name,
        date_format(d.date_day, 'MMM') as month_name_short,

        cast(date_trunc('month', d.date_day) as date) as month_start_date,
        cast(cast(
        timestampadd(day, -1, timestampadd(month, 1, date_trunc('month', d.date_day)))
        as date) as date) as month_end_date,

        cast(
            date_trunc('month', d.prior_year_date_day) as date
        ) as prior_year_month_start_date,
        cast(
            cast(
        timestampadd(day, -1, timestampadd(month, 1, date_trunc('month', d.prior_year_date_day)))
        as date) as date
        ) as prior_year_month_end_date,

        cast(
            date_part('quarter', d.date_day) as integer
        ) as quarter_of_year,
        cast(
            date_trunc('quarter', d.date_day) as date
        ) as quarter_start_date,
        cast(cast(
        timestampadd(day, -1, timestampadd(quarter, 1, date_trunc('quarter', d.date_day)))
        as date) as date) as quarter_end_date,

        cast(
            date_part('year', d.date_day) as integer
        ) as year_number,
        cast(date_trunc('year', d.date_day) as date) as year_start_date,
        cast(cast(
        timestampadd(day, -1, timestampadd(year, 1, date_trunc('year', d.date_day)))
        as date) as date) as year_end_date
    from dates_with_prior_year_dates d
    order by 1


    )

    , dim_dates as (
        select
            md5(cast(concat(coalesce(cast(date_day as string), '_dbt_utils_surrogate_key_null_')) as string)) as date_sk
            , raw_dates.*
        from raw_dates
    )

select *
from dim_dates