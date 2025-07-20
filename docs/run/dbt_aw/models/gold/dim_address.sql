
    
  create or replace table `adventure_works`.`gold`.`dim_address`
  
  (
    
      address_sk string,
    
      address_id string,
    
      business_entity_id string,
    
      territory_id string,
    
      country_name string,
    
      city string,
    
      address_line1 string,
    
      address_line2 string,
    
      country_region_name string,
    
      state_province_code string,
    
      state_province_id string,
    
      country_region_code string,
    
      postal_code string,
    
      address_type_id string,
    
      is_only_state_province_flag string
    
    
  )

  
  using delta
  
  
  
  
  
  
  

  