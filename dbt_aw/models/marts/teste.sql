with fct_sales as (
    select *
    from {{ ref('fct_sales') }}
)

, dim_product as (
    select *
    from {{ ref('dim_product') }}
)

, dim_address as (
    select *
    from {{ ref('dim_address') }}
)

, base as (
    select
        fct_sales.date_order_date,
        dim_address.country_name,
        dim_address.city,
        dim_address.country_region_name,
        dim_product.product_subcategory_name,
        sum(fct_sales.order_qty) as qty
    from fct_sales
    left join dim_product
        on fct_sales.product_fk = dim_product.product_sk
    left join dim_address
        on fct_sales.ship_to_address_id = dim_address.address_id
    group by 
        fct_sales.date_order_date,
        dim_address.country_name,
        dim_address.city,
        dim_address.country_region_name,
        dim_product.product_subcategory_name
)

, pivoted as (
    select
        date_order_date,
        country_name,
        city,
        country_region_name
        {% set subcategorias = dbt_utils.get_column_values(
            table=ref('dim_product'),
            column='product_subcategory_name',
            max_records=500
        ) %}
        {% for sc in subcategorias %}
        , sum(case when product_subcategory_name = '{{ sc }}' then qty else 0 end) as {{ sc | lower | replace(" ", "_") | replace("-", "_") }}
        {% endfor %}
    from base
    group by
        date_order_date,
        country_name,
        city,
        country_region_name
)

select *
from pivoted
