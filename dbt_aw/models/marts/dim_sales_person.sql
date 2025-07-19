with
    dim_sales_person as (
        select
            {{ dbt_utils.generate_surrogate_key(
                ['business_entity_id'
                , 'sales_person_id'
                , 'address_id']
            ) }} as sales_person_sk
            , business_entity_id
            , sales_person_id
            , address_id
            , first_name
            , last_name
            , store_name
            , sales_last_year
            , sales_quota
            , sales_ytd
            , commission_pct
            , bonus
            , middle_name
            , person_type
            , suffix
            , title
            , email_promotion
            , territory_id
        from {{ ref('int_sales_person') }}
    )

select *
from dim_sales_person
