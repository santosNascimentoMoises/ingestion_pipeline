with
    sales as (
        select *
        from {{ ref('fct_sales') }}
    )

    , dim_addres as (
        select *
        from {{ ref('dim_address') }}
    )

    , dim_product as (
        select *
        from {{ ref('dim_product') }}
    )

    , dim_customer as (
        select *
        from {{ ref('dim_customer') }}
    )

    , dim_dates as (
        select *
        from {{ ref('dim_dates') }}
    )

    , dim_store as (
        select *
        from {{ ref('dim_store') }}
    )

    , sales_joined as (
        select
            sales.date_order_date
            , sales.sales_sk
            , order_qty
            , dim_product.product_subcategory_name
            , dim_addres.address_id
            , dim_customer.person_type
            , case
                when person_type = 'SC'
                    then 'store contact'
                when person_type = 'IN'
                    then 'individual customer'
            end as person_type_name
            , coalesce(dim_store.store_name,'direct') as store_name
        from sales
        left join dim_product
            on sales.product_fk = dim_product.product_sk
        left join dim_customer
            on sales.customer_fk = dim_customer.customer_sk
        left join dim_addres
            on sales.ship_to_address_id = dim_addres.address_id
        left join dim_store
            on sales.sales_person_id = dim_store.sales_person_id
        qualify row_number() over (
            partition by
                sales.sales_sk
            order by sales.sales_sk
        ) = 1
    )

    , final as (
        select 
            date_order_date
            , product_subcategory_name
            , address_id
            , person_type
            , store_name
            , sum(order_qty) as product_qty_day
        from sales_joined
        group by
            date_order_date
            , product_subcategory_name
            , address_id
            , person_type
            , store_name
    )

select *
from final
