with 
    product_inventory as (
        select
            Bin
            , LocationID
            , ModifiedDate
            , ProductID
            , Quantity
            , Shelf
            , rowguid
            , load_at
        from `adventure_works`.`raw`.`product_inventory`
    )

    , renamed as (
        select
            Bin::int as bin
            , substring_index(LocationID, '.', 1) as location_id
            , from_unixtime(cast(ModifiedDate as bigint) / 1000)::timestamp as modified_date
            , substring_index(ProductID, '.', 1) as product_id
            , Quantity::int as quantity
            , Shelf::string as shelf
            , load_at::timestamp as load_at
        from product_inventory
    )

select *
from renamed