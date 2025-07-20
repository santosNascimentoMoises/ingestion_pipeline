
    
  create or replace table `adventure_works`.`stg`.`stg_sales_person`
  
  (
    
      bonus float,
    
      business_entity_id string,
    
      commission_pct float,
    
      sales_last_year float,
    
      sales_quota float,
    
      sales_ytd float,
    
      territory_id string,
    
      load_at timestamp
    
    
  )

  
  using delta
  
  
  
  
  
  
  

  