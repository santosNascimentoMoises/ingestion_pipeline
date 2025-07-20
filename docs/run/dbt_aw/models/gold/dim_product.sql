
    
  create or replace table `adventure_works`.`gold`.`dim_product`
  
  (
    
      product_sk string,
    
      product_id string,
    
      product_category_id string,
    
      product_subcategory_id string,
    
      product_model_id string,
    
      product_name string,
    
      product_category_name string,
    
      product_subcategory_name string,
    
      product_size string,
    
      style string,
    
      class string,
    
      color string,
    
      days_to_manufacture int,
    
      discontinued_date string,
    
      finished_goods_flag string,
    
      list_price float,
    
      make_flag string,
    
      modified_date timestamp,
    
      product_line string,
    
      product_number string,
    
      reorder_point string,
    
      safety_stock_level string,
    
      sell_end_date timestamp,
    
      sell_start_date timestamp,
    
      size_unit_measure_code string,
    
      standard_cost float,
    
      product_weight float,
    
      weight_unit_measure_code string
    
    
  )

  
  using delta
  
  
  
  
  
  
  

  