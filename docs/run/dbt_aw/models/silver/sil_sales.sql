
    
  create or replace table `adventure_works`.`silver`.`sil_sales`
  
  (
    
      account_number string,
    
      bill_to_address_id string,
    
      comment string,
    
      credit_card_approval_code string,
    
      credit_card_id string,
    
      currency_rate_id string,
    
      customer_id string,
    
      freight float,
    
      online_order_flag string,
    
      purchase_order_number string,
    
      revision_number string,
    
      sales_order_id string,
    
      sales_order_number string,
    
      sales_person_id string,
    
      ship_method_id string,
    
      ship_to_address_id string,
    
      sales_status string,
    
      sub_total float,
    
      tax_amt float,
    
      territory_id string,
    
      total_duenumer float,
    
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
    
      carrier_tracking_number string,
    
      line_total float,
    
      order_qty string,
    
      product_id string,
    
      sales_order_detail_id string,
    
      special_offer_id string,
    
      unit_price float,
    
      unit_price_discount float,
    
      load_at timestamp
    
    
  )

  
  using delta
  
  
  
  
  
  
  

  