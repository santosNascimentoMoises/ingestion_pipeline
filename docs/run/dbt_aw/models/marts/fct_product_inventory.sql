
    
  create or replace table `adventure_works`.`marts`.`fct_product_inventory`
  
  (
    
      product_fk string,
    
      quantity int,
    
      location_id string,
    
      location_name string,
    
      bin int,
    
      shelf string,
    
      product_id string,
    
      modified_date timestamp
    
    
  )

  
  using delta
  
  
  
  
  
  
  

  