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
            Name::string as product_subcategory_name
            , substring_index(ProductCategoryID , '.', 1) as product_category_id
            , substring_index(ProductSubcategoryID, '.', 1) as product_subcategory_id
            , load_at::timestamp as load_at
        from product_subcategory
    )

select *
from renamed
