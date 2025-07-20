
    
  create or replace table `adventure_works`.`stg`.`stg_address`
  
  (
    
      address_id string,
    
      address_line1 string,
    
      address_line2 string,
    
      city string,
    
      postal_code string,
    
      state_province_id string,
    
      load_at timestamp
    
    
  )

  
  using delta
  
  
  
  
  
  
  

  