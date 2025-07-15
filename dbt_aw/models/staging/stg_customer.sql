with
    customer as (
        select
            AccountNumber
            , CustomerID
            , ModifiedDate
            , PersonID
            , StoreID
            , TerritoryID
            , rowguid
            , load_at
        from {{ source('raw', 'customer') }}
    )

    , renamed as (
        select
            AccountNumber as account_number
            , CustomerID as customer_id

            , substring_index(PersonID, '.', 1) as person_id
            , StoreID as store_id
            , TerritoryID as territory_id
            , load_at::timestamp as load_at
        from customer
    )

select *
from renamed
