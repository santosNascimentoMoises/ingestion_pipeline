with
     __dbt__cte__stg_sales_person as (
with 
    sales_person as (
        select
            Bonus
            , BusinessEntityID
            , CommissionPct
            , ModifiedDate
            , SalesLastYear
            , SalesQuota
            , SalesYTD
            , TerritoryID
            , rowguid
            , load_at
        from `adventure_works`.`raw`.`sales_person`
    )

    , renamed as (
        select
            Bonus::float as bonus
            , substring_index(BusinessEntityID, '.', 1) as business_entity_id
            , CommissionPct::float as commission_pct
            , SalesLastYear::float as sales_last_year
            , SalesQuota::float as sales_quota
            , SalesYTD::float as sales_ytd
            , substring_index(TerritoryID, '.', 1) as territory_id
            , load_at::timestamp as load_at
        from sales_person
    )

select *
from renamed
),  __dbt__cte__stg_person as (
with
    person as (
        select
            AdditionalContactInfo
            , BusinessEntityID
            , Demographics
            , EmailPromotion
            , FirstName
            , LastName
            , MiddleName
            , ModifiedDate
            , NameStyle
            , PersonType
            , Suffix
            , Title
            , rowguid
            , load_at
        from `adventure_works`.`raw`.`person`
    )

    , renamed as (
        select
            BusinessEntityID as business_entity_id
            , EmailPromotion as email_promotion
            , Demographics::string as demographics
            , FirstName::string as first_name
            , LastName::string as last_name
            , MiddleName::string as middle_name
            , PersonType::string as person_type
            , Suffix::string as suffix
            , Title::string as title
            , load_at::timestamp as load_at
        from person
    )

select *
from renamed
),  __dbt__cte__stg_store as (
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
), stg_sales_person as (
        select
            bonus
            , business_entity_id
            , commission_pct
            , sales_last_year
            , sales_quota
            , sales_ytd
            , territory_id
        from __dbt__cte__stg_sales_person
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
        from __dbt__cte__stg_person
    )

    , stg_store as (
        select
            business_entity_id
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