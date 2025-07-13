
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
        from {{ source('raw', 'sales_order_detail') }}
    )

    , renamed as (
        select
            CarrierTrackingNumber::string as carrier_tracking_number
            , LineTotal::number as line_total
            , ModifiedDate::timestamp as modified_date
            , OrderQty::int as order_qty
            , ProductID::int as product_id
            , SalesOrderDetailID::int as sales_order_detail_id
            , SalesOrderID::int as sales_order_id
            , SpecialOfferID::int as special_offer_id
            , UnitPrice::float as unit_price
            , UnitPriceDiscount::float as unit_price_discount
            , load_at::timestamp as load_at
        from sales_order_detail
    )

select *
from renamed
