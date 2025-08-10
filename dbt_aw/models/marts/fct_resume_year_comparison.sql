with
    max_data as (
        select
            max(date_order_date) as max_order_date
        from {{ ref('fct_sales') }}
    )

    , sales_current_year as (
        select
            date_order_date
            , extract(doy from date_order_date) as day_of_year  -- dia no ano
            , sum(unit_price * order_qty) as sales_amount
            , count(distinct sales_order_id) as orders_qty
        from {{ ref('fct_sales') }}
        cross join max_data
        where extract(year from date_order_date) = extract(year from max_data.max_order_date)
          and date_order_date <= max_data.max_order_date
        group by date_order_date
    )

    , sales_prev_year as (
        select
            date_order_date
            , extract(doy from date_order_date) as day_of_year  -- dia no ano
            , sum(unit_price * order_qty) as sales_amount
            , count(distinct sales_order_id) as orders_qty
        from {{ ref('fct_sales') }}
        cross join max_data
        where extract(year from date_order_date) = extract(year from max_data.max_order_date) - 1
          and extract(doy from date_order_date) <= extract(doy from max_data.max_order_date)
        group by date_order_date
    )

select
    cy.day_of_year
    , cy.date_order_date as current_year_date
    , cy.sales_amount as current_year_sales
    , py.date_order_date as prev_year_date
    , py.sales_amount as prev_year_sales
from sales_current_year cy
join sales_prev_year py
    on cy.day_of_year = py.day_of_year
order by cy.day_of_year
