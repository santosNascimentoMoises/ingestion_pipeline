with
    stg_store as (
        select
            business_entity_id
            , demographics
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

    , address_store_joined as (
        select
            stg_store.business_entity_id
            , stg_store.demographics
            , stg_store.store_name
            , stg_store.sales_person_id
            , stg_business_entity_address.address_id
        from stg_store
        left join stg_business_entity_address
            on stg_store.business_entity_id = stg_business_entity_address.business_entity_id
    )

select *
from address_store_joined
