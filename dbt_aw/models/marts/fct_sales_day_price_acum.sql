{{
    config(
        materialized='incremental'
        , unique_key=['sales_person_fk','date_order_date']
        , incremental_strategy='merge'
    )
}}

with
    max_data as (
        select
            max(date_order_date) as max_order_date
        from {{ ref('fct_sales') }}
    )

    , acum_sales as (
        select
            date_order_date
            , sales_person_fk
            , sum(unit_price) as day_sales_price_sum
            , count(sales_order_id) as day_sales_order_quantity
        from {{ ref('fct_sales') }}
        cross join max_data

        {% if is_incremental() %}
        /*                       current_date()*/
        where date_order_date >= max_data.max_order_date - interval 45 days
        {% endif %}

        group by
            date_order_date
            , sales_person_fk
)

select *
from acum_sales
