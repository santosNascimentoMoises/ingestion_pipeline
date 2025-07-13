
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
        from {{ source('raw', 'product_inventory') }}
    )

    renamed as (
        select
            Bin::int as bin
            , LocationID::int as location_id
            , ModifiedDate::timestamp as modified_date
            , ProductID::int as producto_id
            , Quantity::int as quantity
            , Shelf::string as shelf
            , load_at::timestamp as load_at
        from product_inventory
    )

select *
from renamed
