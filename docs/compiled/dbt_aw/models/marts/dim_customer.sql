with
    dim_customer as (
        select
            md5(cast(concat(coalesce(cast(customer_id as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(person_id as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(account_number as string), '_dbt_utils_surrogate_key_null_')) as string)) as customer_sk
            , customer_id
            , person_id
            , business_entity_id
            , account_number
            , first_name
            , last_name
            , middle_name
            , person_type
            , store_id
            , email_promotion
            , suffix
            , title
            , demographics
        from `adventure_works`.`intermediate`.`int_customer`
    )

select *
from dim_customer