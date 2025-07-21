with
    stg_work_order_routing as (
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
        from {{ ref('stg_work_order_routing') }}
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
        from {{ ref('stg_work_order') }}
    )

    , stg_location as (
        select
            location_availability
            , cost_rate
            , location_id
            , modified_date
            , location_name
        from {{ ref('stg_location') }}
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
