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
            BusinessEntityID as business_entity_id
            , Demographics::string as demographics
            , ModifiedDate::timestamp as modified_date
            , Name::string as store_name
            , SalesPersonID::int as sales_person_id
            , load_at::timestamp as load_at
        from store
    )

select *
from renamed
