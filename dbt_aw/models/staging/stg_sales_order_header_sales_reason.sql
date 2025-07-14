with
    sales_order_header_sales_reason as (
        select
            ModifiedDate
            , SalesOrderID
            , SalesReasonID
            , load_at
        from {{ source('raw', 'sales_order_header_sales_reason') }}
    )

    , renamed as (
        select
            from_unixtime(cast(ModifiedDate as bigint) / 1000)::timestamp as modified_date
            , SalesOrderID::int as sales_order_id
            , SalesReasonID::int as sales_reason_id
            , load_at::timestamp as load_at
        from sales_order_header_sales_reason
    )

select *
from renamed
