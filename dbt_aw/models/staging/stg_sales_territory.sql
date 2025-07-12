
with sales_territory as (
    select
        CostLastYear
        , CostYTD
        , CountryRegionCode
        , Group
        , ModifiedDate
        , Name
        , SalesLastYear
        , SalesYTD
        , TerritoryID
        , rowguid
        , load_at
    from {{ source('raw', 'sales_territory') }}
    )

select *
from sales_territory
