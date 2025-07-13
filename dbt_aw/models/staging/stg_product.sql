
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
        from {{ source('raw', 'product') }}
    )

    , renamed as (
        select
            Class::string as class
            , Color::string as color
            , DaysToManufacture::int as days_to_manufacture
            , DiscontinuedDate::timestamp as discontinued_date
            , FinishedGoodsFlag::int as finished_goods_flag
            , ListPrice::float as list_price
            , MakeFlag::int as make_flag
            , ModifiedDate::timestamp as modified_date
            , Name::string as product_name
            , ProductID::int as product_id
            , ProductLine::string as product_line
            , ProductModelID::int as product_model_id
            , ProductNumber::string as product_number
            , ProductSubcategoryID::int as product_subcategory_id
            , ReorderPoint::int as reorder_point
            , SafetyStockLevel::number as safety_stock_level
            , SellEndDate::timestamp as sell_end_date
            , SellStartDate::timestamp as sell_start_date
            , Size::string as product_size
            , SizeUnitMeasureCode::string as size_unit_measure_code
            , StandardCost::float as standard_cost
            , Style::string as style
            , Weight::float as weight
            , WeightUnitMeasureCode::string as weight_unit_measure_code
            , load_at::timestamp as load_at
        from product
    )

select *
from renamed
