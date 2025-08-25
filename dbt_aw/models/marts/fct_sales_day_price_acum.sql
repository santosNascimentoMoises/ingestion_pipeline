with
    max_data as (
        select
            max(date_order_date) as max_order_date
        from {{ ref('fct_sales') }}
    )

    , acum_sales as (
        select
            date_order_date
            , sum(unit_price*order_qty) as day_sales_price_sum
            , count(sales_order_id) as day_sales_order_quantity
            , sum(sum(unit_price * order_qty)) over (
                order by date_order_date
                rows between unbounded preceding and current row
            ) as cumulative_sales_price_sum
        from {{ ref('fct_sales') }}
        cross join max_data
        group by
            date_order_date
)

select *
from acum_sales
