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
            AccountNumber::string as account_number
            , CustomerID::int as customer_id
            , ModifiedDate::timestamp as modified_date
            , PersonID::int as person_id
            , StoreID::int as store_id
            , TerritoryID::int as territory_id
            , load_at::timestamp as load_at
        from customer
    )

select *
from 
