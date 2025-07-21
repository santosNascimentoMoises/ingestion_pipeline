{{
    config(
        materialized='incremental'
        , unique_key=['date_order_date','product_fk']
        , incremental_strategy='merge'
    )
}}

with
    max_data as (
        select
            max(date_order_date) as max_order_date
        from {{ ref('fct_sales') }}
    )

    , sales_day_products_agg as (
        select
            date_order_date
            , product_fk
            , sum(order_qty) as day_products_quantity
            , sum(order_qty * unit_price) as day_products_sub_total
            , sum(order_qty * unit_price_discount) as discount_sub_total
        from {{ ref('fct_sales') }}
        cross join max_data

        {% if is_incremental() %}
        /*                       current_date()*/
        where date_order_date >= max_data.max_order_date - interval 45 days
        {% endif %}

        group by 
            date_order_date
            , product_fk
)

select * 
from sales_day_products_agg
