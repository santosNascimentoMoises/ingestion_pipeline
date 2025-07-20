
      
  
    
        create or replace table `adventure_works`.`snapshots`.`snp_customer_snapshot`
      
      
  using delta
      
      
      
      
      
      
      
      as
      
    

    select *,
        md5(coalesce(cast(customer_id as string ), '')
         || '|' || coalesce(cast(modified_date as string ), '')
        ) as dbt_scd_id,
        modified_date as dbt_updated_at,
        modified_date as dbt_valid_from,
        
  
  coalesce(nullif(modified_date, modified_date), null)
  as dbt_valid_to
from (
        with __dbt__cte__stg_customer as (
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
        from `adventure_works`.`bronze`.`customer`
    )

    , renamed as (
        select
            AccountNumber as account_number
            , CustomerID as customer_id
            , from_unixtime(cast(ModifiedDate as bigint) / 1000)::timestamp as modified_date
            , substring_index(PersonID, '.', 1) as person_id
            , StoreID as store_id
            , TerritoryID as territory_id
            , load_at::timestamp as load_at
        from customer
    )

select *
from renamed
) SELECT * FROM __dbt__cte__stg_customer
    ) sbq



  
  