with
     __dbt__cte__stg_store as (
with 
    store as (
        select
            BusinessEntityID
            , Demographics
            , ModifiedDate
            , Name
            , SalesPersonID
            , rowguid
            , load_at
        from `adventure_works`.`raw`.`store`
    )

    , renamed as (
        select
            substring_index(BusinessEntityID, '.', 1) as business_entity_id
            , Demographics::string as demographics
            , Name::string as store_name
            , substring_index(SalesPersonID, '.', 1) as sales_person_id
            , load_at::timestamp as load_at
        from store
    )

select *
from renamed
),  __dbt__cte__stg_business_entity_address as (
with
    business_entity_address  as (
        select
            AddressID
            , AddressTypeID
            , BusinessEntityID
            , ModifiedDate
            , rowguid
            , load_at
        from `adventure_works`.`raw`.`business_entity_address`
    )

    , renamed as (
        select
            AddressID as address_id
            , AddressTypeID as address_type_id
            , BusinessEntityID as business_entity_id
            , load_at::timestamp as load_at
        from business_entity_address
    )

select *
from renamed
), stg_store as (
        select
            business_entity_id
            , demographics
            , store_name
            , sales_person_id
        from __dbt__cte__stg_store
    )

    , stg_business_entity_address as (
        select
            address_id
            , business_entity_id
        from __dbt__cte__stg_business_entity_address
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