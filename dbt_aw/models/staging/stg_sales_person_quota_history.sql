
with sales_person_quota_history as (
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
    from {{ source('raw', 'sales_person_quota_history') }}
    )

select *
from sales_person_quota_history
