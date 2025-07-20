with
     __dbt__cte__stg_customer as (
with
    customer as (
        select
            AccountNumber
            , CustomerID
            , ModifiedDate
            , PersonID
            , StoreID
            , TerritoryID
            , rowguid
            , load_at
        from `adventure_works`.`bronze`.`customer`
    )

    , renamed as (
        select
            AccountNumber as account_number
            , CustomerID as customer_id
            , from_unixtime(cast(ModifiedDate as bigint) / 1000)::timestamp as modified_date
            , substring_index(PersonID, '.', 1) as person_id
            , substring_index(StoreID, '.', 1)  as store_id
            , TerritoryID as territory_id
            , load_at::timestamp as load_at
        from customer
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
        from `adventure_works`.`bronze`.`person`
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
), stg_customer as (
        select
            account_number
            , customer_id
            , person_id
            , store_id
        from __dbt__cte__stg_customer
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
        from __dbt__cte__stg_person
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