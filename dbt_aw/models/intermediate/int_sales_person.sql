with
    stg_sales_person as (
        select
            bonus
            , business_entity_id
            , commission_pct
            , sales_last_year
            , sales_quota
            , sales_ytd
            , territory_id
        from {{ ref('stg_sales_person') }}
    )

    , stg_person as (
        select
            business_entity_id
            , email_promotion
            , first_name
            , last_name
            , middle_name
            , person_type
            , suffix
            , title
        from {{ ref('stg_person') }}
    )

    , stg_store as (
        select
            business_entity_id
            , store_name
            , sales_person_id
        from {{ ref('stg_store') }}
    )

    , stg_business_entity_address as (
        select
            address_id
            , business_entity_id
        from {{ ref('stg_business_entity_address') }}
    )

    , sales_person_store_joined as (
        select
            stg_sales_person.bonus
            , stg_sales_person.business_entity_id
            , stg_sales_person.commission_pct
            , stg_sales_person.sales_last_year
            , stg_sales_person.sales_quota
            , stg_sales_person.sales_ytd
            , stg_sales_person.territory_id
            , stg_person.email_promotion
            , stg_person.first_name
            , stg_person.last_name
            , stg_person.middle_name
            , stg_person.person_type
            , stg_person.suffix
            , stg_person.title
            , stg_store.store_name
            , stg_store.sales_person_id 
            , stg_business_entity_address.address_id
        from stg_sales_person
        left join stg_person
            on stg_sales_person.business_entity_id = stg_person.business_entity_id
        left join stg_store
            on stg_sales_person.business_entity_id = stg_store.sales_person_id
        left join stg_business_entity_address
            on stg_sales_person.business_entity_id = stg_business_entity_address.business_entity_id
        qualify row_number() over (
            partition by
                stg_sales_person.business_entity_id
                , stg_store.sales_person_id
                , stg_business_entity_address.address_id
            order by stg_sales_person.business_entity_id
        ) = 1
    )

select *
from sales_person_store_joined
