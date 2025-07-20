-- back compat for old kwarg name
  
  
  
  
  
  
      
          
              
              
          
              
              
          
              
              
          
      
  

    merge
    into
        `adventure_works`.`gold`.`fct_product_inventory` as DBT_INTERNAL_DEST
    using
        `fct_product_inventory__dbt_tmp` as DBT_INTERNAL_SOURCE
    on
        
                  DBT_INTERNAL_SOURCE.product_fk <=> DBT_INTERNAL_DEST.product_fk
              
    and 
                  DBT_INTERNAL_SOURCE.modified_date <=> DBT_INTERNAL_DEST.modified_date
              
    and 
                  DBT_INTERNAL_SOURCE.location_id <=> DBT_INTERNAL_DEST.location_id
              
    when matched
        then update set
            *
    when not matched
        then insert
            *

