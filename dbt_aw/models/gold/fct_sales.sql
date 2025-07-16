with
    sales as (
        select
            account_number
            , bill_to_address_id
            , comment
            , credit_card_approval_code
            , credit_card_id
            , currency_rate_id
            , customer_id
            , freight
            , online_order_flag
            , purchase_order_number
            , revision_number
            , sales_order_id
            , sales_order_number
            , sales_person_id
            , ship_method_id
            , ship_to_address_id
            , sales_status
            , sub_total
            , tax_amt
            , territory_id
            , total_duenumer
            /*date time columns*/
            , order_date
            , due_date
            , ship_date
            , date_order_date
            , time_order_date
            , epoch_sec_oder_date
            , date_ship_date
            , time_ship_date
            , epoch_sec_ship_date
            , date_due_date
            , time_due_date
            , epoch_sec_due_date
            , carrier_tracking_number
            , line_total
            , order_qty
            , product_id
            , sales_order_detail_id
            , special_offer_id
            , unit_price
            , unit_price_discount
            , load_at
        from {{ ref('sil_sales') }}
    )

    , dim_product as (
        select
            product_sk
            , product_id
        from {{ ref('dim_product') }}
    )

    , dim_sales_person as (
        select
            sales_person_sk
            , sales_person_id
        from {{ ref('dim_sales_person') }}
    )

    , dim_customer as (
        select
            customer_sk
            , customer_id
        from {{ ref('dim_customer') }}
    )

    , dim_dates as (
        select
            date_sk
            , date_day
        from {{ ref('dim_dates') }}
    )

    , sales_joined as (
        select
            sales.sales_order_id
            , sales.sales_order_detail_id
            , sales.customer_id
            , sales.sales_person_id
            , sales.product_id
            , sales.order_qty
            , sales.sub_total
            , sales.unit_price
            , sales.unit_price_discount
            , sales.special_offer_id
            , sales.account_number
            , sales.sales_status
            , sales.tax_amt
            , sales.credit_card_id
            , sales.ship_method_id
            , sales.currency_rate_id
            , sales.bill_to_address_id
            , sales.ship_to_address_id
            , sales.territory_id
            , sales.sales_order_number
            , sales.credit_card_approval_code
            , sales.freight
            , sales.online_order_flag
            , sales.purchase_order_number
            , sales.revision_number
            , sales.total_duenumer
            , sales.carrier_tracking_number
            , sales.line_total
            , sales.comment
            /*sales.sales date time columns*/
            , sales.order_date
            , sales.due_date
            , sales.ship_date
            , sales.date_order_date
            , sales.time_order_date
            , sales.epoch_sec_oder_date
            , sales.date_ship_date
            , sales.time_ship_date
            , sales.epoch_sec_ship_date
            , sales.date_due_date
            , sales.time_due_date
            , sales.epoch_sec_due_date
            , sales.load_at

            /*dim_product*/
            , product_sk as product_fk

            /*dim_sales_person*/
            , sales_person_sk as sales_person_fk
            
            /*dim_customer*/
            , customer_sk as customer_fk
            
            /*dim_dates*/
            , date_sk as date_fk
        from sales
        left join dim_product
            on sales.product_id = dim_product.product_id
        left join dim_sales_person
            on sales.sales_person_id = dim_sales_person.sales_person_id
        left join dim_customer
            on sales.customer_id = dim_customer.customer_id
        left join dim_dates
            on sales.date_order_date = dim_dates.date_day
        qualify row_number() over (
            partition by
                sales.sales_order_id
                , sales.sales_order_detail_id
                , sales.customer_id
                , sales.sales_person_id
            order by sales.sales_order_id
        ) = 1
    )

    /*generating surrogate key*/
    , fct_sales as (
        select
            {{ dbt_utils.generate_surrogate_key(
                ['sales_order_id'
                , 'sales_order_detail_id']
            ) }} as sales_sk
            , sales_order_id
            , sales_order_detail_id
            , customer_id
            , sales_person_id
            , product_id
            , order_qty
            , sub_total
            , unit_price
            , unit_price_discount
            , special_offer_id
            , account_number
            , sales_status
            , tax_amt
            , credit_card_id
            , ship_method_id
            , product_fk
            , sales_person_fk
            , customer_fk
            , date_fk
            , currency_rate_id
            , bill_to_address_id
            , ship_to_address_id
            , territory_id
            , sales_order_number
            , credit_card_approval_code
            , freight
            , online_order_flag
            , purchase_order_number
            , revision_number
            , total_duenumer
            , carrier_tracking_number
            , line_total
            , comment
            /*sales date time columns*/
            , order_date
            , due_date
            , ship_date
            , date_order_date
            , time_order_date
            , epoch_sec_oder_date
            , date_ship_date
            , time_ship_date
            , epoch_sec_ship_date
            , date_due_date
            , time_due_date
            , epoch_sec_due_date
            , load_at
        from sales_joined
    )

select *
from fct_sales
