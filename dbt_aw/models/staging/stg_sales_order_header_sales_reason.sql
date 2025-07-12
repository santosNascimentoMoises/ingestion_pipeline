
with sales_order_header_sales_reason as (
    select
        ModifiedDate
        , SalesOrderID
        , SalesReasonID
        , load_at
    from {{ source('raw', 'sales_order_header_sales_reason') }}
    )

select *
from sales_order_header_sales_reason
