

with
    sil_product_inventory as (
        select
            bin
            , location_id
            , modified_date
            , product_id
            , quantity
            , shelf
            , location_name
        from `adventure_works`.`silver`.`sil_product_inventory`
    )

    , dim_product as (
        select
            product_sk
            , product_id
        from `adventure_works`.`gold`.`dim_product`
    )

    , inventory_joined_dim_product as (
        select
            dim_product.product_sk as product_fk
            , sil_product_inventory.quantity
            , sil_product_inventory.location_id
            , sil_product_inventory.location_name
            , sil_product_inventory.bin
            , sil_product_inventory.shelf
            , sil_product_inventory.product_id
            , sil_product_inventory.modified_date
        from sil_product_inventory
        left join dim_product
            on sil_product_inventory.product_id = dim_product.product_id
        qualify row_number() over (
            partition by
                sil_product_inventory.location_id
                , sil_product_inventory.product_id
            order by sil_product_inventory.location_id
        ) = 1
    )

select *
from inventory_joined_dim_product