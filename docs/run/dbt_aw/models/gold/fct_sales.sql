
    
  create or replace table `adventure_works`.`gold`.`fct_sales`
  
  (
    
      sales_sk string,
    
      sales_order_id string,
    
      sales_order_detail_id string,
    
      customer_id string,
    
      sales_person_id string,
    
      product_id string,
    
      order_qty string,
    
      sub_total float,
    
      unit_price float,
    
      unit_price_discount float,
    
      special_offer_id string,
    
      account_number string,
    
      sales_status string,
    
      tax_amt float,
    
      credit_card_id string,
    
      ship_method_id string,
    
      product_fk string,
    
      sales_person_fk string,
    
      customer_fk string,
    
      currency_rate_id string,
    
      bill_to_address_id string,
    
      ship_to_address_id string,
    
      territory_id string,
    
      sales_order_number string,
    
      credit_card_approval_code string,
    
      freight float,
    
      online_order_flag string,
    
      purchase_order_number string,
    
      revision_number string,
    
      total_duenumer float,
    
      carrier_tracking_number string,
    
      line_total float,
    
      comment string,
    
      order_date string,
    
      due_date string,
    
      ship_date string,
    
      date_order_date date,
    
      time_order_date string,
    
      epoch_sec_oder_date bigint,
    
      date_ship_date date,
    
      time_ship_date string,
    
      epoch_sec_ship_date bigint,
    
      date_due_date date,
    
      time_due_date string,
    
      epoch_sec_due_date bigint,
    
      load_at timestamp
    
    
  )

  
  using delta
  
  
  
  
  
  
  

  