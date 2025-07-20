with
     __dbt__cte__stg_work_order_routing as (
with
    work_order_routing as (
        select
            ActualCost
            , ActualEndDate 
            , ActualResourceHrs
            , ActualStartDate
            , LocationID
            , ModifiedDate
            , OperationSequence
            , PlannedCost
            , ProductID
            , ScheduledEndDate
            , ScheduledStartDate 
            , WorkOrderID
            , load_at
        from `adventure_works`.`bronze`.`work_order_routing`
    )

    , renamed as (
        select
            ActualCost::float as actual_cost
            , from_unixtime(cast(ActualEndDate as bigint) / 1000)::timestamp as actual_end_date
            , ActualResourceHrs::float as actual_resource_hrs
            , from_unixtime(cast(ActualStartDate as bigint) / 1000)::timestamp as actual_start_date
            , substring_index(LocationID, '.', 1) as location_id
            , from_unixtime(cast(ModifiedDate as bigint) / 1000)::timestamp as modified_date
            , OperationSequence as operation_sequence
            , PlannedCost::float as planned_cost
            , substring_index(ProductID, '.', 1) as product_id
            , from_unixtime(cast(ScheduledEndDate as bigint) / 1000)::timestamp as scheduled_end_date
            , from_unixtime(cast(ScheduledStartDate as bigint) / 1000)::timestamp as scheduled_start_date
            , substring_index(WorkOrderID, '.', 1) as work_order_id
            , load_at::timestamp as load_at
        from work_order_routing
    )

select *
from renamed
),  __dbt__cte__stg_work_order as (
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
        from `adventure_works`.`bronze`.`work_order`
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
),  __dbt__cte__stg_location as (
with
    location_raw as (
        select
            Availability
            , CostRate
            , LocationID
            , ModifiedDate
            , Name
            , load_at
        from `adventure_works`.`bronze`.`location`
    )

    , renamed as (
        select
            substring_index(Availability, '.', 1)::int as location_availability
            , CostRate::float as cost_rate
            , substring_index(LocationID, '.', 1) as location_id
            , from_unixtime(cast(ModifiedDate as bigint) / 1000)::timestamp as modified_date
            , Name::string location_name
            , load_at::timestamp load_at
        from location_raw
    )

select *
from renamed
), stg_work_order_routing as (
        select
            actual_cost
            , actual_end_date
            , actual_resource_hrs
            , actual_start_date
            , location_id
            , operation_sequence
            , planned_cost
            , product_id
            , scheduled_end_date
            , scheduled_start_date
            , work_order_id
        from __dbt__cte__stg_work_order_routing
    )

    , stg_work_order as (
        select
            work_due_date
            , work_end_date
            , order_qty
            , product_id
            , scrap_reason_id
            , scrapped_qty
            , work_start_date
            , stocked_qty
            , work_order_id
        from __dbt__cte__stg_work_order
    )

    , stg_location as (
        select
            location_availability
            , cost_rate
            , location_id
            , modified_date
            , location_name
        from __dbt__cte__stg_location
    )

    , routing_joined_order as (
        select
            stg_work_order.work_order_id
            , stg_work_order.work_due_date
            , stg_work_order.work_end_date
            , stg_work_order.order_qty
            , stg_work_order.scrap_reason_id
            , stg_work_order.scrapped_qty
            , stg_work_order.work_start_date
            , stg_work_order.stocked_qty
            /**/
            , stg_work_order_routing.actual_cost
            , stg_work_order_routing.actual_resource_hrs
            , stg_work_order_routing.location_id
            , stg_work_order_routing.operation_sequence
            , stg_work_order_routing.planned_cost
            , stg_work_order_routing.product_id
            , stg_work_order_routing.scheduled_start_date
            , stg_work_order_routing.scheduled_end_date
            , stg_work_order_routing.actual_end_date
            , stg_work_order_routing.actual_start_date
            /**/
            , stg_location.location_availability
            , stg_location.cost_rate
            , stg_location.location_name
        from stg_work_order
        left join stg_work_order_routing
            on stg_work_order_routing.work_order_id = stg_work_order.work_order_id
        left join stg_location
            on stg_work_order_routing.location_id = stg_location.location_id
        qualify row_number() over (
            partition by
                stg_work_order.work_order_id
                , stg_location.location_id
            order by stg_location.location_id
        ) = 1
    )

select *
from routing_joined_order