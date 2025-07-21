with
    int_sales_reason as (
        select
            {{ dbt_utils.generate_surrogate_key(
                ['sales_reason_id']
            ) }} as reason_sk
            , reason_name
            , reason_type
            , sales_reason_id
        from {{ ref('int_sales_reason') }} 
    )

select *
from int_sales_reason
