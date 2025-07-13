with 
    currency as (
        select
            CurrencyCode
            , ModifiedDate
            , Name
            , load_at
        from {{ source('raw', 'currency') }}
    )

    , renamed as (
        select
            CurrencyCode::string as currency_code
            , ModifiedDate::timestamp as modified_date
            , Name::string as currency_name
            , load_at::timestamp as load_at
        from currency
    )

select *
from renamed
