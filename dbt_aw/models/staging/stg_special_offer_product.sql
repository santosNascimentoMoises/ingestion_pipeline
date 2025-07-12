
with special_offer_product as (
    select
        ModifiedDate
        , ProductID
        , SpecialOfferID
        , rowguid
        , load_at
    from {{ source('raw', 'special_offer_product') }}
    )

select *
from special_offer_product
