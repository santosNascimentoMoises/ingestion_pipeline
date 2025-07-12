
with address as (
    select
        AddressID
        , AddressLine1
        , AddressLine2
        , City
        , ModifiedDate
        , PostalCode
        , StateProvinceID
        , rowguid
        , load_at
    from {{ source('raw', 'address') }}
    )

select *
from address
