with 
    sales_person as (
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
        from `adventure_works`.`raw`.`sales_person`
    )

    , renamed as (
        select
            Bonus::float as bonus
            , substring_index(BusinessEntityID, '.', 1) as business_entity_id
            , CommissionPct::float as commission_pct
            , SalesLastYear::float as sales_last_year
            , SalesQuota::float as sales_quota
            , SalesYTD::float as sales_ytd
            , substring_index(TerritoryID, '.', 1) as territory_id
            , load_at::timestamp as load_at
        from sales_person
    )

select *
from renamed