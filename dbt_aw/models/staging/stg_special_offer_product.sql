with
    special_offer_product as (
        select
            ModifiedDate
            , ProductID
            , SpecialOfferID
            , rowguid
            , load_at
        from {{ source('raw', 'special_offer_product') }}
    )

    , renamed as (
        select
            ModifiedDate::timestamp as modified_date
            , ProductID::int as product_id
            , SpecialOfferID::int as special_offer_id
            , load_at::timestamp as load_at
        from special_offer_product
    )

select *
from renamed
