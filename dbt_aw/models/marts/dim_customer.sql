with
    dim_customer as (
        select
            {{ dbt_utils.generate_surrogate_key(
                ['customer_id'
                , 'business_entity_id'
                , 'account_number']
            ) }} as customer_sk
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
        from {{ ref('int_customer') }}
    )

select *
from dim_customer
