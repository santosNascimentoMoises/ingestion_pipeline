with
     __dbt__cte__stg_business_entity as (
with
    business_entity as (
        select
            BusinessEntityID
            , ModifiedDate
            , rowguid
            , load_at
    from `adventure_works`.`raw`.`business_entity`
    )

    , renamed as (
        select
            BusinessEntityID as business_entity_id
            , load_at::timestamp as load_at
        from business_entity
    )

select *
from renamed
),  __dbt__cte__stg_business_entity_address as (
with
    business_entity_address  as (
        select
            AddressID
            , AddressTypeID
            , BusinessEntityID
            , ModifiedDate
            , rowguid
            , load_at
        from `adventure_works`.`raw`.`business_entity_address`
    )

    , renamed as (
        select
            AddressID as address_id
            , AddressTypeID as address_type_id
            , BusinessEntityID as business_entity_id
            , load_at::timestamp as load_at
        from business_entity_address
    )

select *
from renamed
),  __dbt__cte__stg_address as (
with
    address_table as (
        select
            AddressID
            , AddressLine1
            , AddressLine2
            , City
            , ModifiedDate
            , PostalCode
            , StateProvinceID
            , rowguid
            , load_at
        from `adventure_works`.`raw`.`address`
    )

    , renamed as (
        select
            AddressID as address_id
            , AddressLine1::string as address_line1
            , AddressLine2::string as address_line2
            , City::string as city
            , PostalCode::string as postal_code
            , StateProvinceID as state_province_id
            , load_at::timestamp as load_at
        from address_table
    )

select *
from renamed
),  __dbt__cte__stg_state_province as (
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
),  __dbt__cte__stg_country_region as (
with 
    country_region as (
        select
            CountryRegionCode
            , ModifiedDate
            , Name
            , load_at
        from `adventure_works`.`raw`.`country_region`
    )

    , renamed as (
        select
            CountryRegionCode as country_region_code
            , Name::string as country_name
            , load_at::timestamp as load_at
        from country_region
    )

select *
from renamed
), stg_business_entity as (
        select
            business_entity_id
        from __dbt__cte__stg_business_entity
    )

    , stg_business_entity_address as (
        select
            address_id
            , address_type_id
            , business_entity_id
        from __dbt__cte__stg_business_entity_address
    )

    , stg_address as (
        select
            address_id
            , address_line1
            , address_line2
            , city
            , postal_code
            , state_province_id
        from __dbt__cte__stg_address
    )

    , stg_state_province as (
        select
            country_region_code
            , is_only_state_province_flag
            , country_region_name
            , state_province_code
            , state_province_id
            , territory_id
        from __dbt__cte__stg_state_province
    )

    , stg_country_region as (
        select
            country_region_code
            , country_name
        from __dbt__cte__stg_country_region
    )

    , final_joined as (
        select
            stg_business_entity_address.address_id
            , stg_business_entity_address.address_type_id
            , stg_business_entity_address.business_entity_id
            , stg_address.address_line1
            , stg_address.address_line2
            , stg_address.city
            , stg_address.postal_code
            , stg_address.state_province_id
            , stg_state_province.country_region_code
            , stg_state_province.is_only_state_province_flag
            , stg_state_province.country_region_name
            , stg_state_province.state_province_code
            , stg_state_province.territory_id
            , stg_country_region.country_name
        from stg_business_entity_address
        left join stg_address
            on stg_business_entity_address.address_id = stg_address.address_id
        left join stg_state_province
            on stg_address.state_province_id = stg_state_province.state_province_id
        left join stg_country_region
            on stg_state_province.country_region_code = stg_country_region.country_region_code
        qualify row_number() over (
            partition by
                stg_business_entity_address.address_id
                , stg_business_entity_address.business_entity_id
                , stg_address.state_province_id
                , stg_country_region.country_region_code
            order by stg_business_entity_address.business_entity_id
        ) = 1
    )

select *
from final_joined