
with product_cost_history as (
    select
        EndDate
        , ModifiedDate
        , ProductID
        , StandardCost
        , StartDate
        , load_at
    from {{ source('raw', 'product_cost_history') }}
    )

select *
from 
