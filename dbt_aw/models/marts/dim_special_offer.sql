with
    special_offer as (
        select
            category
            , description
            , discount_pct
            , end_date_offer
            , max_qty
            , min_qty
            , modified_date
            , special_offer_id
            , start_date_offer
            , special_offer_type
            , load_at
        from {{ ref('stg_special_offer') }}
    )

select *
from special_offer
