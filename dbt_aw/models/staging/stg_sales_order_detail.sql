
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
            CarrierTrackingNumber::string as 
            , LineTotal::number as 
            , ModifiedDate::timestamp as 
            , OrderQty::int as 
            , ProductID::int as 
            , SalesOrderDetailID::int as 
            , SalesOrderID::int as 
            , SpecialOfferID::int as 
            , UnitPrice::float as 
            , UnitPriceDiscount::float as 
            , load_at::timestamp as load_at
        from sales_order_detail
    )

select *
from renamed
