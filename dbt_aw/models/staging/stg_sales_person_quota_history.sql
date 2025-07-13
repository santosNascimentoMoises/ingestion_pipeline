with 
    sales_person_quota_history as (
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

    , renamed as (
        select
            Bonus as bonus
            , BusinessEntityID as business_entity_id
            , CommissionPct as commission_pct
            , ModifiedDate as modified_date
            , SalesLastYear as sales_last_year
            , SalesQuota as sales_quota
            , SalesYTD as sales_ytd
            , TerritoryID as territory_id
        from sales_person_quota_history
    )

select *
from renamed
