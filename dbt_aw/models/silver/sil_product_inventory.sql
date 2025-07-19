with 
    stg_product_inventory as (
        select
            bin
            , location_id
            , modified_date
            , product_id
            , quantity
            , shelf
        from {{ ref('stg_product_inventory') }}
    )

    , stg_location as (
        select
            location_availability
            , cost_rate
            , location_id
            , modified_date
            , location_name
        from {{ ref('stg_location') }}
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
