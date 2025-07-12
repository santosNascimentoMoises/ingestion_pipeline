
with sales_order_detail as (
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

select *
from sales_order_detail
