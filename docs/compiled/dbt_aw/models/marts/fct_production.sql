with
    dim_product as (
        select
            product_sk
            , product_id
        from `adventure_works`.`marts`.`dim_product`
    )

    , int_production as (
        select
            work_order_id
            , product_id
            , work_start_date
            , work_end_date
            , order_qty
            , planned_cost
            , actual_cost
            , actual_resource_hrs
            , location_id
            , location_name
            , stocked_qty
            , scheduled_start_date
            , scheduled_end_date
            , actual_end_date
            , actual_start_date
            , work_due_date
            , operation_sequence
            , location_availability
            , cost_rate
            , scrapped_qty
            , scrap_reason_id
        from `adventure_works`.`intermediate`.`int_production`
    )

    , fct_production as (
        select
            md5(cast(concat(coalesce(cast(int_production.work_order_id as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(int_production.product_id as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(int_production.operation_sequence as string), '_dbt_utils_surrogate_key_null_')) as string)) as production_sk
            , int_production.work_order_id
            , int_production.product_id
            , int_production.work_start_date
            , int_production.work_end_date
            , int_production.order_qty
            , int_production.planned_cost
            , int_production.actual_cost
            , int_production.actual_resource_hrs
            , int_production.location_id
            , int_production.location_name
            , int_production.stocked_qty
            , int_production.scheduled_start_date
            , int_production.scheduled_end_date
            , int_production.actual_end_date
            , int_production.actual_start_date
            , int_production.work_due_date
            , int_production.operation_sequence
            , int_production.location_availability
            , int_production.cost_rate
            , int_production.scrapped_qty
            , int_production.scrap_reason_id
            , dim_product.product_sk as product_fk
        from int_production
        left join dim_product
            on dim_product.product_id = int_production.product_id
        qualify row_number() over (
            partition by
                int_production.work_order_id
                , int_production.product_id
            order by int_production.product_id
        ) = 1
    )

select *
from fct_production