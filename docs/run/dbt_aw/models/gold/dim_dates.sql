
    
  create or replace table `adventure_works`.`gold`.`dim_dates`
  
  (
    
      date_sk string,
    
      date_day date,
    
      prior_date_day date,
    
      next_date_day date,
    
      prior_year_date_day date,
    
      prior_year_over_year_date_day date,
    
      day_of_week int,
    
      day_of_week_iso int,
    
      day_of_week_name string,
    
      day_of_week_name_short string,
    
      day_of_month int,
    
      day_of_year int,
    
      week_start_date date,
    
      week_end_date date,
    
      prior_year_week_start_date date,
    
      prior_year_week_end_date date,
    
      week_of_year int,
    
      iso_week_start_date date,
    
      iso_week_end_date date,
    
      prior_year_iso_week_start_date date,
    
      prior_year_iso_week_end_date date,
    
      iso_week_of_year int,
    
      iso_year_week string,
    
      prior_year_week_of_year int,
    
      prior_year_iso_week_of_year int,
    
      month_of_year int,
    
      month_name string,
    
      month_name_short string,
    
      month_start_date date,
    
      month_end_date date,
    
      prior_year_month_start_date date,
    
      prior_year_month_end_date date,
    
      quarter_of_year int,
    
      quarter_start_date date,
    
      quarter_end_date date,
    
      year_number int,
    
      year_start_date date,
    
      year_end_date date
    
    
  )

  
  using delta
  
  
  
  
  
  
  

  