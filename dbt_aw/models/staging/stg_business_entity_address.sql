with
    business_entity_address  as (
        select
            AddressID
            , AddressTypeID
            , BusinessEntityID
            , ModifiedDate
            , rowguid
            , load_at
        from {{ source('raw', 'business_entity_address') }}
    )

    , renamed as (
        select
            AddressID as address_id
            , AddressTypeID as address_type_id
            , BusinessEntityID as business_entity_id
            , load_at::timestamp as load_at
        from business_entity_address
    )

select *
from renamed
