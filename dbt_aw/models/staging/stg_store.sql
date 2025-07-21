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
        from {{ source('raw', 'store') }}
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
