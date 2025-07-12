
with sales_person as (
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
    from {{ source('raw', 'sales_person') }}
    )

select *
from sales_person
