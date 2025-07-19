with
    dim_address as (
        select
            {{ dbt_utils.generate_surrogate_key(
                ['address_id'
                , 'business_entity_id']
            ) }} as address_sk
            , address_id
            , business_entity_id
            , territory_id
            , country_name
            , city
            , address_line1
            , address_line2
            , country_region_name
            , state_province_code
            , state_province_id
            , country_region_code
            , postal_code
            , address_type_id
            , is_only_state_province_flag
        from {{ ref('int_address') }}
    )

select *
from dim_address
