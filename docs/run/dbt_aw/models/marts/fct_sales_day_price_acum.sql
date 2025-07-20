
    
  create or replace table `adventure_works`.`marts`.`fct_sales_day_price_acum`
  
  (
    
      date_order_date date,
    
      sales_person_fk string,
    
      day_sales_price_sum double,
    
      day_sales_order_quantity bigint
    
    
  )

  
  using delta
  
  
  
  
  
  
  

  