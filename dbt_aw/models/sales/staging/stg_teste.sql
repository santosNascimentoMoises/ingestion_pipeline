{{ config(materialized='ephemeral') }}

with src as (
    select *
    from {{ source('bronze_sales', 'address') }}
)

select *
from src
