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
            EndDate::timestamp as history_end_date
            , ModifiedDate::timestamp as modified_date
            , ProductID::int as product_id
            , StandardCost::float as standard_cost
            , StartDate::timestamp as history_start_date
            , load_at::timestamp as load_at
        from product_cost_history
    )

select *
from renamed
