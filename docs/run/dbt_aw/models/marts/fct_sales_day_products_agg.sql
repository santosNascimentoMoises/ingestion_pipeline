
    
  create or replace table `adventure_works`.`marts`.`fct_sales_day_products_agg`
  
  (
    
      date_order_date date,
    
      product_fk string,
    
      day_products_quantity double,
    
      day_products_sub_total double,
    
      discount_sub_total double
    
    
  )

  
  using delta
  
  
  
  
  
  
  

  