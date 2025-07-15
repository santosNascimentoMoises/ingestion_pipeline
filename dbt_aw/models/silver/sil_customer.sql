with
    stg_customer as (
        select
            account_number
            , customer_id
            , person_id
            , store_id
        from {{ ref('stg_customer') }}
    )

    , stg_person as (
        select
            business_entity_id
            , email_promotion
            , demographics
            , first_name
            , last_name
            , middle_name
            , person_type
            , suffix
            , title
        from {{ ref('stg_person') }}
    )

    , stg_business_entity as (
        select
            business_entity_id
        from {{ ref('stg_business_entity') }}
    )

    , customer_person_joined as (
        select
            stg_customer.account_number
            , stg_customer.customer_id
            , stg_customer.person_id
            , stg_customer.store_id

            , stg_person.business_entity_id
            , stg_person.email_promotion
            , stg_person.demographics
            , stg_person.first_name
            , stg_person.last_name
            , stg_person.middle_name
            , stg_person.person_type
            , stg_person.suffix
            , stg_person.title
        from stg_person
        left join stg_customer
            on stg_customer.person_id = stg_person.business_entity_id
    )

select *
from customer_person_joined
