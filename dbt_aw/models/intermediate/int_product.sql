with
    stg_product as (
        select
            class
            , color
            , days_to_manufacture
            , discontinued_date
            , finished_goods_flag
            , list_price
            , make_flag
            , modified_date
            , product_name
            , product_id
            , product_line
            , product_model_id
            , product_number
            , product_subcategory_id
            , reorder_point
            , safety_stock_level
            , sell_end_date
            , sell_start_date
            , product_size
            , size_unit_measure_code
            , standard_cost
            , style
            , product_weight
            , weight_unit_measure_code
            , load_at
        from {{ ref('stg_product') }}
    )

    , stg_product_category as (
        select
            product_category_name
            , product_category_id
        from {{ ref('stg_product_category') }}
    )

    , stg_product_subcategory as (
        select
            product_subcategory_name
            , product_category_id
            , product_subcategory_id
        from {{ ref('stg_product_subcategory') }}
    )

    , product_joined as (
        select
            stg_product.class
            , stg_product.color
            , stg_product.days_to_manufacture
            , stg_product.discontinued_date
            , stg_product.finished_goods_flag
            , stg_product.list_price
            , stg_product.make_flag
            , stg_product.modified_date
            , stg_product.product_name
            , stg_product.product_id
            , stg_product.product_line
            , stg_product.product_model_id
            , stg_product.product_number
            , stg_product.reorder_point
            , stg_product.safety_stock_level
            , stg_product.sell_end_date
            , stg_product.sell_start_date
            , stg_product.product_size
            , stg_product.size_unit_measure_code
            , stg_product.standard_cost
            , stg_product.style
            , stg_product.product_weight
            , stg_product.weight_unit_measure_code
            , stg_product.load_at
            , stg_product_subcategory.product_subcategory_name
            , stg_product_subcategory.product_subcategory_id
            , stg_product_subcategory.product_category_id
            , stg_product_category.product_category_name
        from stg_product
        left join stg_product_subcategory
            on stg_product.product_subcategory_id = stg_product_subcategory.product_subcategory_id
        left join stg_product_category
            on stg_product_subcategory.product_category_id = stg_product_category.product_category_id
    )

select *
from product_joined
