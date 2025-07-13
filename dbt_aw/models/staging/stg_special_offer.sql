with
    special_offer as (
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

    , renamed as (
        select
            Category::string as category
            , Description::string as description
            , DiscountPct::float as discount_pct
            , EndDate::timestamp as end_date
            , MaxQty::int as max_qty
            , MinQty::int as min_qty
            , ModifiedDate::timestamp as modified_date
            , SpecialOfferID::int as special_offer_id
            , StartDate::timestamp as start_date
            , Type::string as special_offer_type
            , load_at::timestamp as load_at
        from special_offer
    )

select *
from renamed
