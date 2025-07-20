
    
  create or replace table `adventure_works`.`intermediate`.`int_production`
  
  (
    
      work_order_id string,
    
      work_due_date timestamp,
    
      work_end_date timestamp,
    
      order_qty int,
    
      scrap_reason_id string,
    
      scrapped_qty int,
    
      work_start_date timestamp,
    
      stocked_qty int,
    
      actual_cost float,
    
      actual_resource_hrs float,
    
      location_id string,
    
      operation_sequence string,
    
      planned_cost float,
    
      product_id string,
    
      scheduled_start_date timestamp,
    
      scheduled_end_date timestamp,
    
      actual_end_date timestamp,
    
      actual_start_date timestamp,
    
      location_availability int,
    
      cost_rate float,
    
      location_name string
    
    
  )

  
  using delta
  
  
  
  
  
  
  

  