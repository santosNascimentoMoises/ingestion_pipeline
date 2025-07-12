
with sales_reason as (
    select
        ModifiedDate
        , Name
        , ReasonType
        , SalesReasonID
        , load_at
    from {{ source('raw', 'sales_reason') }}
    )

select *
from sales_reason
