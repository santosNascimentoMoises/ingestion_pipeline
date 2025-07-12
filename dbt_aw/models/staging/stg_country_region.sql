
with country_region as (
    select
        CountryRegionCode
        , ModifiedDate
        , Name
        , load_at
    from {{ source('raw', 'country_region') }}
    )

select *
from country_region
