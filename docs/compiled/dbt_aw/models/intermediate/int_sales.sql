with
     __dbt__cte__stg_sales_order_header as (
with
    sales_order_header as (
        select
            AccountNumber
            , BillToAddressID
            , Comment
            , CreditCardApprovalCode
            , CreditCardID
            , CurrencyRateID
            , CustomerID
            , DueDate
            , Freight
            , ModifiedDate
            , OnlineOrderFlag
            , OrderDate
            , PurchaseOrderNumber
            , RevisionNumber
            , SalesOrderID
            , SalesOrderNumber
            , SalesPersonID
            , ShipDate
            , ShipMethodID
            , ShipToAddressID
            , Status
            , SubTotal
            , TaxAmt
            , TerritoryID
            , TotalDue
            , rowguid
            , load_at
        from `adventure_works`.`raw`.`sales_order_header`    
    )

    , renamed as (
        select
            AccountNumber::string as account_number
            , substring_index(BillToAddressID, '.', 1) as bill_to_address_id
            , Comment::string as comment
            , CreditCardApprovalCode::string as credit_card_approval_code
            , substring_index(CreditCardID, '.', 1) as credit_card_id
            , substring_index(CurrencyRateID, '.', 1) as currency_rate_id
            , substring_index(CustomerID, '.', 1) as customer_id
            , DueDate as due_date
            , Freight::float as freight
            , OnlineOrderFlag::string as online_order_flag
            , OrderDate as order_date
            , PurchaseOrderNumber::string as purchase_order_number
            , substring_index(RevisionNumber, '.', 1) as revision_number
            , substring_index(SalesOrderID, '.', 1) as sales_order_id
            , SalesOrderNumber::string as sales_order_number
            , substring_index(SalesPersonID, '.', 1) as sales_person_id
            , ShipDate as ship_date
            , substring_index(ShipMethodID, '.', 1) as ship_method_id
            , substring_index(ShipToAddressID, '.', 1) as ship_to_address_id
            , substring_index(Status, '.', 1) as sales_status
            , SubTotal::float as sub_total
            , TaxAmt::float as tax_amt
            , substring_index(TerritoryID, '.', 1) as territory_id
            , TotalDue::float as total_duenumer
            , load_at::timestamp as load_at
        from sales_order_header
    )

select *
from renamed
),  __dbt__cte__stg_sales_order_detail as (
with
    sales_order_detail as (
        select
            CarrierTrackingNumber
            , LineTotal
            , ModifiedDate
            , OrderQty
            , ProductID
            , SalesOrderDetailID
            , SalesOrderID
            , SpecialOfferID
            , UnitPrice
            , UnitPriceDiscount
            , rowguid
            , load_at
        from `adventure_works`.`raw`.`sales_order_detail`
    )

    , renamed as (
        select
            CarrierTrackingNumber::string as carrier_tracking_number
            , LineTotal::float as line_total
            , substring_index(OrderQty, '.', 1) as order_qty
            , substring_index(ProductID, '.', 1) as product_id
            , substring_index(SalesOrderDetailID, '.', 1) as sales_order_detail_id
            , substring_index(SalesOrderID, '.', 1) as sales_order_id
            , substring_index(SpecialOfferID, '.', 1) as special_offer_id
            , UnitPrice::float as unit_price
            , UnitPriceDiscount::float as unit_price_discount
            , load_at::timestamp as load_at
        from sales_order_detail
    )

select *
from renamed
), stg_sales_order_header as (
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
        from __dbt__cte__stg_sales_order_header
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
        from __dbt__cte__stg_sales_order_detail
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
        from stg_sales_order_header
        left join stg_sales_order_detail
            on stg_sales_order_header.sales_order_id = stg_sales_order_detail.sales_order_id
        qualify row_number() over (
            partition by
                stg_sales_order_header.sales_order_id
                , stg_sales_order_detail.sales_order_detail_id
            order by stg_sales_order_header.sales_order_id
        ) = 1
    )

select *
from header_detail_joined