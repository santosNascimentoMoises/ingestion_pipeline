with
    stg_sales_reason as (
        select
            reason_name
            , reason_type
            , sales_reason_id
        from {{ ref('stg_sales_reason') }} 
    )

select *
from stg_sales_reason
