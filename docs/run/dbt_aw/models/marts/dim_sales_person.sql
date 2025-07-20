
    
  create or replace table `adventure_works`.`marts`.`dim_sales_person`
  
  (
    
      sales_person_sk string,
    
      business_entity_id string,
    
      sales_person_id string,
    
      address_id string,
    
      first_name string,
    
      last_name string,
    
      store_name string,
    
      sales_last_year float,
    
      sales_quota float,
    
      sales_ytd float,
    
      commission_pct float,
    
      bonus float,
    
      middle_name string,
    
      person_type string,
    
      suffix string,
    
      title string,
    
      email_promotion string,
    
      territory_id string
    
    
  )

  
  using delta
  
  
  
  
  
  
  

  