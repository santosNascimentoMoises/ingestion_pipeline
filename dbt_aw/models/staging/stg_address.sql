with
    address_table as (
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

    , renamed as (
        select
            AddressID::int as address_id
            , AddressLine1::string as address_line1
            , AddressLine2::string as address_line2
            , City::string as city
            , ModifiedDate::timestamp as modified_date
            , PostalCode::string as postal_code
            , StateProvinceID::int as state_province_id
            , load_at::timestamp as load_at
        from address_table
    )

select *
from renamed
