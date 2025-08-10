with
    max_data as (
        select
            max(date_order_date) as max_order_date
        from {{ ref('fct_sales') }}
    )

    , acum_sales_current as (
        select
            date_order_date
            , sum(unit_price * order_qty) as day_sales_price_sum
            , count(distinct sales_order_id) as day_sales_order_quantity
        from {{ ref('fct_sales') }}
        cross join max_data
        where date_order_date >= max_data.max_order_date - interval '45 day'
        and date_order_date <= max_data.max_order_date
        group by date_order_date
    )

    , acum_sales_prev_year as (
        select
            date_order_date
            , sum(unit_price * order_qty) as day_sales_price_sum
            , count(distinct sales_order_id) as day_sales_order_quantity
        from {{ ref('fct_sales') }}
        cross join max_data
        where date_order_date >= (max_data.max_order_date - interval '1 year') - interval '45 day'
          and date_order_date <= (max_data.max_order_date - interval '1 year')
        group by date_order_date
    )

select
    'current' as period_type,
    *
from acum_sales_current

union all

select
    'previous_year' as period_type,
    *
from acum_sales_prev_year
