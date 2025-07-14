with
    sales_territory as (
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

    , renamed as (
        select
            CostLastYear::float as cost_last_year
            , CostYTD::float as cost_ytd
            , CountryRegionCode::string as country_region_code
            , Group::string as group
            , from_unixtime(cast(ModifiedDate as bigint) / 1000)::timestamp as modified_date
            , Name::string as sales_territory_name
            , SalesLastYear::float as sales_last_year
            , SalesYTD::float as sales_ytd
            , TerritoryID::int as territory_id
            , load_at::timestamp as load_at
        from sales_territory
    )

select *
from renamed
