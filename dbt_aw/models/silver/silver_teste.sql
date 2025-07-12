
with base as (
    select *
    from {{ ref('stg_teste') }}
)

select * from base
