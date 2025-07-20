
    
  create or replace table `adventure_works`.`gold`.`fct_teste`
  
  (
    
      average_rate float,
    
      currency_rate_date timestamp,
    
      currency_rate_id int,
    
      end_of_day_rate float,
    
      from_currency_code string,
    
      modified_date timestamp,
    
      to_currency_code string,
    
      load_at timestamp
    
    
  )

  
  using delta
  
  
  
  
  
  
  

  