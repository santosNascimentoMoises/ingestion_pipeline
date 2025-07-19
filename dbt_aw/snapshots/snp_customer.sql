{% snapshot snp_customer %}
{{
    config(
      unique_key='customer_id',
      strategy='timestamp',
      updated_at='modified_date'
    )
}}

SELECT * FROM {{ ref('stg_customer') }}

{% endsnapshot %}
