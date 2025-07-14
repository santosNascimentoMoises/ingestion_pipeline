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
        from {{ source('raw', 'sales_person') }}
    )

    , renamed as (
        select
            Bonus::float as bonus
            , BusinessEntityID::int as business_entity_id
            , CommissionPct::float as commission_pct
            , from_unixtime(cast(ModifiedDate as bigint) / 1000)::timestamp as modified_date
            , SalesLastYear::float as sales_last_year
            , SalesQuota::float as sales_quota
            , SalesYTD::float as sales_ytd
            , TerritoryID::int as territory_id
            , load_at::timestamp as load_at
        from sales_person
    )

select *
from renamed
