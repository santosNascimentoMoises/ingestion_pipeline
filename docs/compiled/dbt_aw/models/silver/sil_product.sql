with
     __dbt__cte__stg_product as (
with
    product as (
        select
            Class
            , Color
            , DaysToManufacture
            , DiscontinuedDate
            , FinishedGoodsFlag
            , ListPrice
            , MakeFlag
            , ModifiedDate
            , Name
            , ProductID
            , ProductLine
            , ProductModelID
            , ProductNumber
            , ProductSubcategoryID
            , ReorderPoint
            , SafetyStockLevel
            , SellEndDate
            , SellStartDate
            , Size
            , SizeUnitMeasureCode
            , StandardCost
            , Style
            , Weight
            , WeightUnitMeasureCode
            , rowguid
            , load_at
        from `adventure_works`.`bronze`.`product`
    )

    , renamed as (
        select
            Class::string as class
            , Color::string as color
            , try_cast(DaysToManufacture as int) as days_to_manufacture
            , from_unixtime(cast(DiscontinuedDate as bigint) / 1000) as discontinued_date
            , FinishedGoodsFlag as finished_goods_flag
            , ListPrice::float as list_price
            , MakeFlag as make_flag
            , from_unixtime(cast(ModifiedDate as bigint) / 1000)::timestamp as modified_date
            , Name::string as product_name
            , substring_index(ProductID, '.', 1) as product_id
            , ProductLine::string as product_line
            , substring_index(ProductModelID, '.', 1) as product_model_id
            , ProductNumber::string as product_number
            , substring_index(ProductSubcategoryID, '.', 1) as product_subcategory_id
            , ReorderPoint as reorder_point
            , SafetyStockLevel as safety_stock_level
            , from_unixtime(cast(SellEndDate as bigint) / 1000)::timestamp as sell_end_date
            , from_unixtime(cast(SellStartDate as bigint) / 1000)::timestamp as sell_start_date
            , Size::string as product_size
            , SizeUnitMeasureCode::string as size_unit_measure_code
            , StandardCost::float as standard_cost
            , Style::string as style
            , Weight::float as product_weight
            , WeightUnitMeasureCode::string as weight_unit_measure_code
            , load_at::timestamp as load_at
        from product
    )

select *
from renamed
),  __dbt__cte__stg_product_category as (
with 
    product_category as (
        select
            ModifiedDate
            , Name
            , ProductCategoryID
            , rowguid
            , load_at
        from `adventure_works`.`bronze`.`product_category`
    )

    , renamed as (
        select
            from_unixtime(cast(ModifiedDate as bigint) / 1000)::timestamp as modified_date
            , Name::string as product_category_name
            , substring_index(ProductCategoryID, '.', 1) as product_category_id
            , load_at::timestamp as load_at
        from product_category
    )

select *
from renamed
),  __dbt__cte__stg_product_subcategory as (
with 
    product_subcategory as (
        select
            ModifiedDate
            , Name
            , ProductCategoryID
            , ProductSubcategoryID
            , rowguid
            , load_at
        from `adventure_works`.`bronze`.`product_subcategory`
    )

    , renamed as (
        select
            Name::string as product_subcategory_name
            , substring_index(ProductCategoryID , '.', 1) as product_category_id
            , substring_index(ProductSubcategoryID, '.', 1) as product_subcategory_id
            , load_at::timestamp as load_at
        from product_subcategory
    )

select *
from renamed
), stg_product as (
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
        from __dbt__cte__stg_product
    )

    , stg_product_category as (
        select
            product_category_name
            , product_category_id
        from __dbt__cte__stg_product_category
    )

    , stg_product_subcategory as (
        select
            product_subcategory_name
            , product_category_id
            , product_subcategory_id
        from __dbt__cte__stg_product_subcategory
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