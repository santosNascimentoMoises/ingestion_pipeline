
with sales_territory_history as (
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

select *
from sales_territory_history
