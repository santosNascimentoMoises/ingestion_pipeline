
with customer as (
    select
        AccountNumber
        , CustomerID
        , ModifiedDate
        , PersonID
        , StoreID
        , TerritoryID
        , rowguid
        , load_at
    from {{ source('raw', 'customer') }}
    )

select *
from 
