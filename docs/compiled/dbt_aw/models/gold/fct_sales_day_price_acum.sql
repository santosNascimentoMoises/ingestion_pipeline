

with
    max_data as (
        select
            max(date_order_date) as max_order_date
        from `adventure_works`.`gold`.`fct_sales`
    )

    , acum_sales as (
        select
            date_order_date
            , sales_person_fk
            , sum(unit_price) as day_sales_price_sum
            , count(sales_order_id) as day_sales_order_quantity
        from `adventure_works`.`gold`.`fct_sales`
        cross join max_data

        
        /*                       current_date()*/
        where date_order_date >= max_data.max_order_date - interval 45 days
        

        group by
            date_order_date
            , sales_person_fk
)

select *
from acum_sales