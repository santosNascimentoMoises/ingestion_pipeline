with
    dim_product as (
        select
            {{ dbt_utils.generate_surrogate_key(
                ['product_id'
                , 'product_category_id'
                , 'product_subcategory_id'
                , 'product_model_id']
            ) }} as product_sk
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
        from {{ ref('sil_product') }}
    )

select *
from dim_product
