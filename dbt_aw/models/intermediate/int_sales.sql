with
    stg_sales_order_header as (
        select
            account_number
            , bill_to_address_id
            , comment
            , credit_card_approval_code
            , case
                when credit_card_approval_code is null
                    then 'other'
                else 'credit card'
            end as payment_type
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

            /*order date columns*/
            , order_date
            , date_format(
                case
                    when regexp_like(order_date, '^\\d{13}$')
                        then timestamp_millis(cast(order_date as bigint))
                    else to_timestamp(order_date)
                end
                , 'yyyy-MM-dd\'T\'HH:mm:ss'
            ) as order_date_formated
            , to_date(order_date_formated) as date_order_date
            , date_format(to_timestamp(order_date_formated),'HH:mm:ss') as time_order_date
            , unix_timestamp(to_timestamp(order_date_formated)) as epoch_sec_oder_date

            /*ship date columns*/
            , ship_date
            , date_format(
                case
                    when regexp_like(ship_date, '^\\d{13}$')
                        then timestamp_millis(cast(ship_date as bigint))
                    else to_timestamp(ship_date)
                end
                , 'yyyy-MM-dd\'T\'HH:mm:ss'
            ) as ship_date_formated
            , to_date(ship_date_formated) as date_ship_date
            , date_format(to_timestamp(ship_date_formated),'HH:mm:ss') as time_ship_date
            , unix_timestamp(to_timestamp(ship_date_formated)) as epoch_sec_ship_date
            
            /*due_date columns*/
            , due_date
            , date_format(
                case
                    when regexp_like(due_date, '^\\d{13}$')
                        then timestamp_millis(cast(due_date as bigint))
                    else to_timestamp(due_date)
                end
                , 'yyyy-MM-dd\'T\'HH:mm:ss'
            ) as due_date_formated
            , to_date(due_date_formated) as date_due_date
            , date_format(to_timestamp(due_date_formated),'HH:mm:ss') as time_due_date
            , unix_timestamp(to_timestamp(due_date_formated)) as epoch_sec_due_date
        from {{ ref('stg_sales_order_header') }}
    )

    , stg_sales_order_detail as (
        select
            carrier_tracking_number
            , line_total
            , order_qty
            , product_id
            , sales_order_detail_id
            , sales_order_id
            , special_offer_id
            , unit_price
            , unit_price_discount
            , load_at
        from {{ ref('stg_sales_order_detail') }}
    )

    , stg_header_sales_reason as (
        select
            sales_order_id
            , sales_reason_id
        from {{ ref('stg_sales_order_header_sales_reason') }}
    )

    , header_detail_joined as (
        select
            stg_sales_order_header.account_number
            , stg_sales_order_header.bill_to_address_id
            , stg_sales_order_header.comment
            , stg_sales_order_header.credit_card_approval_code
            , stg_sales_order_header.credit_card_id
            , stg_sales_order_header.currency_rate_id
            , stg_sales_order_header.customer_id
            , stg_sales_order_header.freight
            , stg_sales_order_header.online_order_flag
            , stg_sales_order_header.purchase_order_number
            , stg_sales_order_header.revision_number
            , stg_sales_order_header.sales_order_id
            , stg_sales_order_header.sales_order_number
            , stg_sales_order_header.sales_person_id
            , stg_sales_order_header.ship_method_id
            , stg_sales_order_header.ship_to_address_id
            , stg_sales_order_header.sales_status
            , stg_sales_order_header.sub_total
            , stg_sales_order_header.tax_amt
            , stg_sales_order_header.territory_id
            , stg_sales_order_header.total_duenumer
            , stg_sales_order_header.payment_type
            /*sales_order_header date time columns*/
            , stg_sales_order_header.order_date
            , stg_sales_order_header.due_date
            , stg_sales_order_header.ship_date
            , stg_sales_order_header.date_order_date
            , stg_sales_order_header.time_order_date
            , stg_sales_order_header.epoch_sec_oder_date
            , stg_sales_order_header.date_ship_date
            , stg_sales_order_header.time_ship_date
            , stg_sales_order_header.epoch_sec_ship_date
            , stg_sales_order_header.date_due_date
            , stg_sales_order_header.time_due_date
            , stg_sales_order_header.epoch_sec_due_date
            , stg_sales_order_detail.carrier_tracking_number
            , stg_sales_order_detail.line_total
            , stg_sales_order_detail.order_qty
            , stg_sales_order_detail.product_id
            , stg_sales_order_detail.sales_order_detail_id
            , stg_sales_order_detail.special_offer_id
            , stg_sales_order_detail.unit_price
            , stg_sales_order_detail.unit_price_discount
            , stg_sales_order_detail.load_at
            , stg_header_sales_reason.sales_reason_id
            , case
                when stg_header_sales_reason.sales_reason_id is null
                    then 'other'
                else stg_header_sales_reason.sales_reason_id
            end as sales_reason_id_all_categorized
        from stg_sales_order_header
        left join stg_sales_order_detail
            on stg_sales_order_header.sales_order_id = stg_sales_order_detail.sales_order_id
        left join stg_header_sales_reason
            on stg_sales_order_header.sales_order_id = stg_header_sales_reason.sales_order_id
        qualify row_number() over (
            partition by
                stg_sales_order_header.sales_order_id
                , stg_sales_order_detail.sales_order_detail_id
                , stg_header_sales_reason.sales_order_id
            order by stg_sales_order_header.sales_order_id
        ) = 1
    )

select *
from header_detail_joined
