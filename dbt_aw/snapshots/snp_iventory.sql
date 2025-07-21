{% snapshot snp_iventory %}
{{
    config(
      unique_key=['product_fk','modified_date','location_id','bin','shelf'],
      strategy='timestamp',
      updated_at='modified_date'
    )
}}

SELECT
  product_fk
  , quantity
  , location_id
  , location_name
  , bin
  , shelf
  , product_id
  , modified_date
FROM {{ ref('fct_product_inventory') }}

{% endsnapshot %}
