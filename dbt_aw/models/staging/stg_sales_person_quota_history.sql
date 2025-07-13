with
    sales_person_quota_history as (
        select
            BusinessEntityID
            , ModifiedDate
            , QuotaDate
            , SalesQuota
            , rowguid
            , load_at
        from {{ source('raw', 'sales_person_quota_history') }}
    )

    , renamed as (
        select
            BusinessEntityID::int as business_entity_id
            , ModifiedDate::timestamp as modified_date
            , QuotaDate::timestamp as quota_date
            , SalesQuota::float as sales_quota
            , load_at::timestamp as load_at
        from sales_person_quota_history
    )

select *
from renamed
