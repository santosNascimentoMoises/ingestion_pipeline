with
    dim_address as (
        select
            {{ dbt_utils.generate_surrogate_key(
                ['person_id'
                , 'address_id'
                , 'business_entity_id']
            ) }} as address_sk
            , address_id
            , business_entity_id
            , person_id
            , territory_id
            , country_region_code
            , country_region_name
            , country_name
            , state_province_code
            , city
            , address_type_id
            , address_line1
            , address_line2
            , postal_code
            , state_province_id
            , is_only_state_province_flag
        from {{ ref('sil_address') }}
    )

select *
from dim_address
