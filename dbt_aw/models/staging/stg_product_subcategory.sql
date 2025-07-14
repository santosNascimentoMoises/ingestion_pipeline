
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
            from_unixtime(cast(ModifiedDate as bigint) / 1000)::timestamp as modified_date
            , Name::string as product_subcategory_name
            , ProductCategoryID as product_category_id
            , ProductSubcategoryID as product_subcategory_id
            , load_at::timestamp as load_at
        from product_subcategory
    )

select *
from renamed
