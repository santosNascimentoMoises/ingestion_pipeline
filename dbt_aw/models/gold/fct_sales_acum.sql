{{
    config(
        materialized='incremental',
        unique_key='sales_sk'
    )
}}

WITH acum_sales AS (
    SELECT
        -- Cria uma chave substituta para garantir a unicidade no modelo incremental 
        date_order_date
        , sales_person_fk
        , customer_fk
        , SUM(unit_price) AS day_sales_price_sum
        , COUNT(sales_order_id) AS day_sales_order_quantity
        
    FROM {{ ref('fct_sales') }}

    {% if is_incremental() %}

    -- Cláusula para processar apenas os dados mais recentes em execuções incrementais
    -- Isso assume que seu orquestrador rodará este modelo uma vez por dia.
    WHERE date_order_date >= (SELECT MAX(date_order_date) FROM {{ this }})

    {% endif %}

    GROUP BY
        date_order_date
        , sales_person_fk
        , customer_fk
)

SELECT *
FROM acum_sales
