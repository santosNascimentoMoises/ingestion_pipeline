
with work_order as (
    select
        DueDate
        , EndDate
        , ModifiedDate
        , OrderQty
        , ProductID
        , ScrapReasonID
        , ScrappedQty
        , StartDate
        , StockedQty
        , WorkOrderID
        , load_at
    from {{ source('raw', 'work_order') }}
    )

select *
from work_order
