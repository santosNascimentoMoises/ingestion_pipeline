{{ config(
    materialized = 'table',
    schema = 'silver',
    tags = ['silver', 'finance']
) }}

with base as (
    select *
    from {{ ref('stg_teste') }}
)

select * from base
