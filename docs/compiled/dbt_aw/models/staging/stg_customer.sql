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
        from `adventure_works`.`raw`.`customer`
    )

    , renamed as (
        select
            AccountNumber as account_number
            , CustomerID as customer_id
            , from_unixtime(cast(ModifiedDate as bigint) / 1000)::timestamp as modified_date
            , substring_index(PersonID, '.', 1) as person_id
            , substring_index(StoreID, '.', 1)  as store_id
            , TerritoryID as territory_id
            , load_at::timestamp as load_at
        from customer
    )

select *
from renamed