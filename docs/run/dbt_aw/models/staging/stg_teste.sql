
  
  
  
  create or replace view `adventure_works`.`silver`.`stg_teste`
  
  as (
    with address_table as (
    select *
    from `adventure_works`.`bronze`.`address`
)

select *
from address_table
  )
