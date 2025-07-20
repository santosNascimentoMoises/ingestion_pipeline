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
        from `adventure_works`.`raw`.`state_province`
    )

    , renamed as (
        select
            CountryRegionCode::string as country_region_code
            , IsOnlyStateProvinceFlag as is_only_state_province_flag
            , Name::string as country_region_name
            , StateProvinceCode::string as state_province_code
            , StateProvinceID as state_province_id
            , TerritoryID as territory_id
            , load_at::timestamp as load_at
        from state_province
    )

select *
from renamed