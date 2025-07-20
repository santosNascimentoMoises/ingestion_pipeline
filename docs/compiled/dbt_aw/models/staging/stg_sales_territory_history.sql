with 
    sales_territory_history as (
        select
            BusinessEntityID
            , EndDate
            , ModifiedDate
            , StartDate
            , TerritoryID
            , rowguid
            , load_at
        from `adventure_works`.`raw`.`sales_territory_history`
    )

    , renamed as (
        select
            BusinessEntityID::int as business_entity_id
            , from_unixtime(cast(EndDate as bigint) / 1000)::timestamp as end_date_history
            , from_unixtime(cast(ModifiedDate as bigint) / 1000)::timestamp as modified_date
            , from_unixtime(cast(StartDat as bigint) / 1000)::timestamp as start_date_history
            , TerritoryID::int as territory_id
            , load_at::timestamp as load_at
        from sales_territory_history
    )

select *
from renamed