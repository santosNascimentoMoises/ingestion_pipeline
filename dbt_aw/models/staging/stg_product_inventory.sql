
with product_inventory as (
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

select *
from product_inventory
