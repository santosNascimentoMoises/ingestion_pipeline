
with product_category as (
    select
        ModifiedDate
        , Name
        , ProductCategoryID
        , rowguid
        , load_at
    from {{ source('raw', 'product_category') }}
    )

select *
from product_category
