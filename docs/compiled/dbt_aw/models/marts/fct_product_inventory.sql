

with
    int_product_inventory as (
        select
            bin
            , location_id
            , modified_date
            , product_id
            , quantity
            , shelf
            , location_name
        from `adventure_works`.`intermediate`.`int_product_inventory`
    )

    , dim_product as (
        select
            product_sk
            , product_id
        from `adventure_works`.`marts`.`dim_product`
    )

    , inventory_joined_dim_product as (
        select
            dim_product.product_sk as product_fk
            , int_product_inventory.quantity
            , int_product_inventory.location_id
            , int_product_inventory.location_name
            , int_product_inventory.bin
            , int_product_inventory.shelf
            , int_product_inventory.product_id
            , int_product_inventory.modified_date
        from int_product_inventory
        left join dim_product
            on int_product_inventory.product_id = dim_product.product_id
        qualify row_number() over (
            partition by
                int_product_inventory.location_id
                , int_product_inventory.product_id
            order by int_product_inventory.location_id
        ) = 1
    )

select *
from inventory_joined_dim_product