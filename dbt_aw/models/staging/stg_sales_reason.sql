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
            from_unixtime(cast(ModifiedDate as bigint) / 1000)::timestamp as modified_date
            , Name::string as reason_name
            , ReasonType::string as reason_type
            , substring_index(SalesReasonID, '.', 1) as sales_reason_id
            , load_at::timestamp as load_at
        from sales_reason
    )

select *
from renamed
