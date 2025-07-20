with
    dim_sales as (
        select
            md5(cast(concat(coalesce(cast(business_entity_id as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(sales_person_id as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(address_id as string), '_dbt_utils_surrogate_key_null_')) as string)) as sales_sk
            , business_entity_id
            , demographics
            , store_name
            , sales_person_id
            , address_id
        from `adventure_works`.`silver`.`sil_sales`
    )

select *
from dim_sales