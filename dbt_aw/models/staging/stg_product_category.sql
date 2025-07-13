
with 
    product_category as (
        select
            ModifiedDate
            , Name
            , ProductCategoryID
            , rowguid
            , load_at
        from {{ source('raw', 'product_category') }}
    )

    , renamed as (
        select
            ModifiedDate::timestamp as modified_date
            , Name::string as product_category_name
            , ProductCategoryID::int as product_category_id
            , load_at::timestamp as load_at
        from product_category
    )

select *
from renamed
