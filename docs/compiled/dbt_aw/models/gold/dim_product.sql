with
    dim_product as (
        select
            md5(cast(concat(coalesce(cast(product_id as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(product_category_id as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(product_subcategory_id as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(product_model_id as string), '_dbt_utils_surrogate_key_null_')) as string)) as product_sk
            , product_id
            , product_category_id
            , product_subcategory_id
            , product_model_id
            , product_name
            , product_category_name
            , product_subcategory_name
            , product_size
            , style
            , class
            , color
            , days_to_manufacture
            , discontinued_date
            , finished_goods_flag
            , list_price
            , make_flag
            , modified_date
            , product_line
            , product_number
            , reorder_point
            , safety_stock_level
            , sell_end_date
            , sell_start_date
            , size_unit_measure_code
            , standard_cost
            , product_weight
            , weight_unit_measure_code
        from `adventure_works`.`silver`.`sil_product`
    )

select *
from dim_product