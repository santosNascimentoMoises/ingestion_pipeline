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
        from {{ source('raw', 'work_order_routing') }}
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
