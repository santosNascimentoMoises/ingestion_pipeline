-- back compat for old kwarg name
  
  
  
  
  
  
      
          
              
              
          
              
              
          
      
  

    merge
    into
        `adventure_works`.`gold`.`fct_sales_day_price_acum` as DBT_INTERNAL_DEST
    using
        `fct_sales_day_price_acum__dbt_tmp` as DBT_INTERNAL_SOURCE
    on
        
                  DBT_INTERNAL_SOURCE.sales_person_fk <=> DBT_INTERNAL_DEST.sales_person_fk
              
    and 
                  DBT_INTERNAL_SOURCE.date_order_date <=> DBT_INTERNAL_DEST.date_order_date
              
    when matched
        then update set
            *
    when not matched
        then insert
            *

