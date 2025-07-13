
with 
    product_subcategory as (
        select
            ModifiedDate
            , Name
            , ProductCategoryID
            , ProductSubcategoryID
            , rowguid
            , load_at
        from {{ source('raw', 'product_subcategory') }}
    )

    , renamed as (
        select
            ModifiedDate::timestamp as modified_date
            , Name::string as product_subcategory_name
            , ProductCategoryID::int as product_category_id
            , ProductSubcategoryID::int as product_subcategory_id
            , load_at::timestamp as load_at
        from product_subcategory
    )

select *
from renamed
