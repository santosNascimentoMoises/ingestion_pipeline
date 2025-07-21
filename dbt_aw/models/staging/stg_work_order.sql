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
            from_unixtime(cast(DueDate as bigint) / 1000)::timestamp as work_due_date
            , from_unixtime(cast(EndDate as bigint) / 1000)::timestamp as work_end_date
            , from_unixtime(cast(ModifiedDate as bigint) / 1000)::timestamp as modified_date
            , OrderQty::int as order_qty
            , substring_index(ProductID, '.', 1) as product_id
            , substring_index(ScrapReasonID, '.', 1) as scrap_reason_id
            , ScrappedQty::int as scrapped_qty
            , from_unixtime(cast(StartDate as bigint) / 1000)::timestamp as work_start_date
            , StockedQty::int as stocked_qty
            , substring_index(WorkOrderID, '.', 1) as work_order_id
            , load_at::timestamp as load_at
        from work_order
    )

select *
from renamed
