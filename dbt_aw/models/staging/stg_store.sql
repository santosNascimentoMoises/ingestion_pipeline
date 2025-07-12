
with store as (
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

select *
from 
