
with currency as (
    select
        CurrencyCode
        , ModifiedDate
        , Name
        , load_at
    from {{ source('raw', 'currency') }}
    )

select *
from currency
