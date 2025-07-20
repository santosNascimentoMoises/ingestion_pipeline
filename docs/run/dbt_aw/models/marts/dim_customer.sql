
    
  create or replace table `adventure_works`.`marts`.`dim_customer`
  
  (
    
      customer_sk string,
    
      customer_id string,
    
      person_id string,
    
      business_entity_id string,
    
      account_number string,
    
      first_name string,
    
      last_name string,
    
      middle_name string,
    
      person_type string,
    
      store_id string,
    
      email_promotion string,
    
      suffix string,
    
      title string,
    
      demographics string
    
    
  )

  
  using delta
  
  
  
  
  
  
  

  