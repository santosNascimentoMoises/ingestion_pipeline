
with base as (
    select *
    from {{ ref('silver_teste') }}
)

select * from base
