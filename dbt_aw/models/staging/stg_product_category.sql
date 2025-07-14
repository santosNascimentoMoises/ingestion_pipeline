
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
            from_unixtime(cast(ModifiedDate as bigint) / 1000)::timestamp as modified_date
            , Name::string as product_category_name
            , ProductCategoryID as product_category_id
            , load_at::timestamp as load_at
        from product_category
    )

select *
from renamed
