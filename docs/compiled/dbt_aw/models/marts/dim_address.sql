with
    dim_address as (
        select
            md5(cast(concat(coalesce(cast(address_id as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(business_entity_id as string), '_dbt_utils_surrogate_key_null_')) as string)) as address_sk
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
        from `adventure_works`.`intermediate`.`int_address`
    )

select *
from dim_address