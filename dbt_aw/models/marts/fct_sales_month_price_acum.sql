with max_data as (
    select
        max(date_order_date) as max_order_date
    from {{ ref('fct_sales') }}
)

, monthly_sales as (
    select
        to_char(date_trunc('month', date_order_date), 'yyyy-MM-dd') as month_order_date
        , sum(unit_price * order_qty) as month_sales_price_sum
        , count(distinct sales_order_id) as month_sales_order_quantity
    from {{ ref('fct_sales') }}
    cross join max_data
    where date_order_date <= max_order_date
    group by date_trunc('month', date_order_date)
)

, acum_sales as (
    select
        month_order_date
        , month_sales_price_sum
        , month_sales_order_quantity
        , sum(month_sales_price_sum) over (
            order by month_order_date
            rows between unbounded preceding and current row
        ) as cumulative_month_sales_price_sum
    from monthly_sales
)

select *
from acum_sales
order by month_order_date
