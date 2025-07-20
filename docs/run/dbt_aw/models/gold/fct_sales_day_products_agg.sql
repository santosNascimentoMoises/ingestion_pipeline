-- back compat for old kwarg name
  
  
  
  
  
  
      
          
              
              
          
              
              
          
      
  

    merge
    into
        `adventure_works`.`gold`.`fct_sales_day_products_agg` as DBT_INTERNAL_DEST
    using
        `fct_sales_day_products_agg__dbt_tmp` as DBT_INTERNAL_SOURCE
    on
        
                  DBT_INTERNAL_SOURCE.date_order_date <=> DBT_INTERNAL_DEST.date_order_date
              
    and 
                  DBT_INTERNAL_SOURCE.product_fk <=> DBT_INTERNAL_DEST.product_fk
              
    when matched
        then update set
            *
    when not matched
        then insert
            *

