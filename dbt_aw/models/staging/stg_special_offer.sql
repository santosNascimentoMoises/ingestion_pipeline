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
            , from_unixtime(cast(EndDate as bigint) / 1000)::timestamp as end_date_offer
            , MaxQty::int as max_qty
            , MinQty::int as min_qty
            , from_unixtime(cast(ModifiedDate as bigint) / 1000)::timestamp as modified_date
            , SpecialOfferID::int as special_offer_id
            , from_unixtime(cast(StartDate as bigint) / 1000)::timestamp as start_date_offer
            , Type::string as special_offer_type
            , load_at::timestamp as load_at
        from special_offer
    )

select *
from renamed
