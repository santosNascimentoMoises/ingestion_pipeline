
with 
    sales_territory_history as (
        select
            BusinessEntityID
            , EndDate
            , ModifiedDate
            , StartDate
            , TerritoryID
            , rowguid
            , load_at
        from {{ source('raw', 'sales_territory_history') }}
    )

    , renamed as (
        select
            BusinessEntityID::int as business_entity_id
            , EndDate::timestamp as end_date
            , ModifiedDate::timestamp as modified_date
            , StartDate as start_date
            , TerritoryID::int as territory_id
            , load_at::timestamp as load_at
        from sales_territory_history
    )

select *
from renamed
