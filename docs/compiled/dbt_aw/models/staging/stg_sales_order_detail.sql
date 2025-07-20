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