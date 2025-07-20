
    
  create or replace table `adventure_works`.`snapshot`.`snp_sales`
  
  (
    
      date_order_date date,
    
      sales_person_fk string,
    
      customer_fk string,
    
      day_sales_price_sum double,
    
      day_sales_order_quantity bigint
    
    
  )

  
  using delta
  
  
  
  
  
  
  

  