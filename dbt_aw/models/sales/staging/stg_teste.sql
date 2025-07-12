-- {{ config(materialized='ephemeral') }}

with address_table as (
    select *
    from {{ source('raw', 'address') }}
)

select *
from address_table
