
with country_region_currency as (
    select
        CountryRegionCode
        , CurrencyCode
        , ModifiedDate
        , load_at
    from {{ source('raw', 'country_region_currency') }}
    )

select *
from country_region_currency
