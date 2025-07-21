with
    raw_dates as (
        {{ dbt_date.get_date_dimension("2005-01-01", "2019-12-31") }}
    )

    , dim_dates as (
        select
            {{ dbt_utils.generate_surrogate_key(
                ['date_day']
            ) }} as date_sk
            , raw_dates.*
        from raw_dates
    )

select *
from dim_dates
