
    
  create or replace table `adventure_works`.`marts`.`fct_production`
  
  (
    
      production_sk string,
    
      work_order_id string,
    
      product_id string,
    
      work_start_date timestamp,
    
      work_end_date timestamp,
    
      order_qty int,
    
      planned_cost float,
    
      actual_cost float,
    
      actual_resource_hrs float,
    
      location_id string,
    
      location_name string,
    
      stocked_qty int,
    
      scheduled_start_date timestamp,
    
      scheduled_end_date timestamp,
    
      actual_end_date timestamp,
    
      actual_start_date timestamp,
    
      work_due_date timestamp,
    
      operation_sequence string,
    
      location_availability int,
    
      cost_rate float,
    
      scrapped_qty int,
    
      scrap_reason_id string,
    
      product_fk string
    
    
  )

  
  using delta
  
  
  
  
  
  
  

  