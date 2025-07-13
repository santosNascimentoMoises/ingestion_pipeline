with 
    country_region as (
        select
            CountryRegionCode
            , ModifiedDate
            , Name
            , load_at
        from {{ source('raw', 'country_region') }}
    )

    , renamed as (
        select
            CountryRegionCode::string as country_region_code
            , ModifiedDate::timestamp modified_date
            , Name::string as country_name
            , load_at::timestamp as load_at
        from country_region
    )

select *
from renamed
