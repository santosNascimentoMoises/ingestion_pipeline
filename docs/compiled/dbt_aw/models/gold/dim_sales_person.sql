with
    dim_sales_person as (
        select
            md5(cast(concat(coalesce(cast(business_entity_id as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(sales_person_id as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(address_id as string), '_dbt_utils_surrogate_key_null_')) as string)) as sales_person_sk
            , business_entity_id
            , sales_person_id
            , address_id
            , first_name
            , last_name
            , store_name
            , sales_last_year
            , sales_quota
            , sales_ytd
            , commission_pct
            , bonus
            , middle_name
            , person_type
            , suffix
            , title
            , email_promotion
            , territory_id
        from `adventure_works`.`silver`.`sil_sales_person`
    )

select *
from dim_sales_person