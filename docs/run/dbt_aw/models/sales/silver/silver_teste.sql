
  
    
        create or replace table `adventure_works`.`silver`.`silver_teste`
      
      
  using delta
      
      
      
      
      
      
      
      as
      with  __dbt__cte__stg_teste as (
-- 

with address_table as (
    select *
    from `adventure_works`.`bronze`.`address`
)

select *
from address_table
), base as (
    select *
    from __dbt__cte__stg_teste
)

select * from base
  