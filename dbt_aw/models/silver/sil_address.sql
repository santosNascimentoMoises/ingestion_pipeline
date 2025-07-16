with
    stg_business_entity as (
        select
            business_entity_id
        from {{ ref('stg_business_entity') }}
    )

    , stg_business_entity_address as (
        select
            address_id
            , address_type_id
            , business_entity_id
        from {{ ref('stg_business_entity_address') }}
    )

    , stg_address as (
        select
            address_id
            , address_line1
            , address_line2
            , city
            , postal_code
            , state_province_id
        from {{ ref('stg_address') }}
    )

    , stg_state_province as (
        select
            country_region_code
            , is_only_state_province_flag
            , country_region_name
            , state_province_code
            , state_province_id
            , territory_id
        from {{ ref('stg_state_province') }}
    )

    , stg_country_region as (
        select
            country_region_code
            , country_name
        from {{ ref('stg_country_region') }}
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
