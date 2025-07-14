
with
    state_province as (
        select
            CountryRegionCode
            , IsOnlyStateProvinceFlag
            , ModifiedDate
            , Name
            , StateProvinceCode
            , StateProvinceID
            , TerritoryID
            , rowguid
            , load_at
        from {{ source('raw', 'state_province') }}
    )

    renamed as (
        select
            CountryRegionCode::string as country_region_code
            , IsOnlyStateProvinceFlag::int as is_only_state_province_flag
            , from_unixtime(cast(ModifiedDate as bigint) / 1000)::timestamp as modified_date
            , Name::string as country_region_name
            , StateProvinceCode::string as state_province_code
            , StateProvinceID::int as state_province_id
            , TerritoryID::int as territory_id
            , load_at::timestamp as load_at
        from state_province
    )

select *
from renamed
