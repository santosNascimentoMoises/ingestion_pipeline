with 
    country_region_currency as (
        select
            CountryRegionCode
            , CurrencyCode
            , ModifiedDate
            , load_at
        from {{ source('raw', 'country_region_currency') }}
    )

    , renamed as (
        select
            CountryRegionCode::string as country_region_code
            , CurrencyCode::string as currency_code
            , from_unixtime(cast(ModifiedDate as bigint) / 1000)::timestamp as modified_date
            , load_at::timestamp as load_at
        from country_region_currency
    )

select *
from renamed
