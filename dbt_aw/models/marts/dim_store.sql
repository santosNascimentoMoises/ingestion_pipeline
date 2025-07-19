with
    dim_sales as (
        select
            {{ dbt_utils.generate_surrogate_key(
                ['business_entity_id'
                , 'sales_person_id'
                , 'address_id']
            ) }} as sales_sk
            , business_entity_id
            , store_name
            , sales_person_id
            , address_id
            , demographics
        from {{ ref('int_store') }}
    )

select *
from dim_sales
