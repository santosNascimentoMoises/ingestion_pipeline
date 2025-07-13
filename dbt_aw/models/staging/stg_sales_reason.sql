with 
    sales_reason as (
        select
            ModifiedDate
            , Name
            , ReasonType
            , SalesReasonID
            , load_at
        from {{ source('raw', 'sales_reason') }}
    )

    , renamed as (
        select
            ModifiedDate::timestamp as modified_date
            , Name::string as reason_name
            , ReasonType::string as reason_type
            , SalesReasonID::int as sales_reason_id
            , load_at::timestamp as load_at
        from sales_reason
    )

select *
from renamed
