

WITH snp_sales AS (
    SELECT
        -- Cria uma chave substituta para garantir a unicidade no modelo incremental 
        date_order_date
        , sales_person_fk
        , customer_fk
        
        -- Agregações diárias
        , SUM(unit_price) AS day_sales_price_sum
        , COUNT(sales_order_id) AS day_sales_order_quantity
        
    FROM `adventure_works`.`gold`.`fct_sales`

    

    GROUP BY
        date_order_date
        , sales_person_fk
        , customer_fk
)

SELECT *
FROM snp_sales