with 
     __dbt__cte__stg_product_inventory as (
with 
    product_inventory as (
        select
            Bin
            , LocationID
            , ModifiedDate
            , ProductID
            , Quantity
            , Shelf
            , rowguid
            , load_at
        from `adventure_works`.`bronze`.`product_inventory`
    )

    , renamed as (
        select
            Bin::int as bin
            , substring_index(LocationID, '.', 1) as location_id
            , from_unixtime(cast(ModifiedDate as bigint) / 1000)::timestamp as modified_date
            , substring_index(ProductID, '.', 1) as product_id
            , Quantity::int as quantity
            , Shelf::string as shelf
            , load_at::timestamp as load_at
        from product_inventory
    )

select *
from renamed
),  __dbt__cte__stg_location as (
with
    location_raw as (
        select
            Availability
            , CostRate
            , LocationID
            , ModifiedDate
            , Name
            , load_at
        from `adventure_works`.`bronze`.`location`
    )

    , renamed as (
        select
            substring_index(Availability, '.', 1)::int as location_availability
            , CostRate::float as cost_rate
            , substring_index(LocationID, '.', 1) as location_id
            , from_unixtime(cast(ModifiedDate as bigint) / 1000)::timestamp as modified_date
            , Name::string location_name
            , load_at::timestamp load_at
        from location_raw
    )

select *
from renamed
), stg_product_inventory as (
        select
            bin
            , location_id
            , modified_date
            , product_id
            , quantity
            , shelf
        from __dbt__cte__stg_product_inventory
    )

    , stg_location as (
        select
            location_availability
            , cost_rate
            , location_id
            , modified_date
            , location_name
        from __dbt__cte__stg_location
    )

    , inventory_joined_location as (
        select
            stg_product_inventory.bin
            , stg_product_inventory.location_id
            , stg_product_inventory.modified_date
            , stg_product_inventory.product_id
            , stg_product_inventory.quantity
            , stg_product_inventory.shelf
            , stg_location.location_name
        from stg_product_inventory
        left join stg_location
            on stg_product_inventory.location_id = stg_location.location_id
        qualify row_number() over (
            partition by
                stg_product_inventory.product_id
                , stg_location.location_id
            order by stg_location.location_id
        ) = 1
    )

select *
from inventory_joined_location