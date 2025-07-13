with
    work_order as (
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

    , renamed as (
        select
            DueDate::timestamp as due_date
            , EndDate::timestamp as end_date
            , ModifiedDate::timestamp as modified_date
            , OrderQty::int as order_qty
            , ProductID::int as product_id
            , ScrapReasonID::int as scrap_reason_id
            , ScrappedQty::int as scrapped_qty
            , StartDate::timestamp as start_date
            , StockedQty::int as stocked_qty
            , WorkOrderID::int as work_order_id
            , load_at::timestamp as load_at
        from work_order
    )

select *
from renamed
