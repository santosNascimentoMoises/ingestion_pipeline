
with product as (
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

select *
from product
