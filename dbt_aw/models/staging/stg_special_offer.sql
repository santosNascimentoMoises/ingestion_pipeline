
with special_offer as (
    select
        Category
        , Description
        , DiscountPct
        , EndDate
        , MaxQty
        , MinQty
        , ModifiedDate
        , SpecialOfferID
        , StartDate
        , Type
        , rowguid
        , load_at
    from {{ source('raw', 'special_offer') }}
    )

select *
from special_offer
