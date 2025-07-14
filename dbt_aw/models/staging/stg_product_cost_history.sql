with 
    product_cost_history as (
        select
            EndDate
            , ModifiedDate
            , ProductID
            , StandardCost
            , StartDate
            , load_at
        from {{ source('raw', 'product_cost_history') }}
    )

    , renamed as (
        select
            from_unixtime(cast(EndDate as bigint) / 1000)::timestamp as history_end_date
            , from_unixtime(cast(ModifiedDate as bigint) / 1000)::timestamp as modified_date
            , ProductID::int as product_id
            , StandardCost::float as standard_cost
            , from_unixtime(cast(StartDate as bigint) / 1000)::timestamp as history_start_date
            , load_at::timestamp as load_at
        from product_cost_history
    )

select *
from renamed
