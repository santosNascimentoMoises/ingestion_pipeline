with
    dim_product as (
        select
            product_sk
            , product_id
        from `adventure_works`.`gold`.`dim_product`
    )

    , sil_production as (
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
        from `adventure_works`.`silver`.`sil_production`
    )

    , fct_production as (
        select
            md5(cast(concat(coalesce(cast(sil_production.work_order_id as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(sil_production.product_id as string), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(sil_production.operation_sequence as string), '_dbt_utils_surrogate_key_null_')) as string)) as production_sk
            , sil_production.work_order_id
            , sil_production.product_id
            , sil_production.work_start_date
            , sil_production.work_end_date
            , sil_production.order_qty
            , sil_production.planned_cost
            , sil_production.actual_cost
            , sil_production.actual_resource_hrs
            , sil_production.location_id
            , sil_production.location_name
            , sil_production.stocked_qty
            , sil_production.scheduled_start_date
            , sil_production.scheduled_end_date
            , sil_production.actual_end_date
            , sil_production.actual_start_date
            , sil_production.work_due_date
            , sil_production.operation_sequence
            , sil_production.location_availability
            , sil_production.cost_rate
            , sil_production.scrapped_qty
            , sil_production.scrap_reason_id
            , dim_product.product_sk as product_fk
        from sil_production
        left join dim_product
            on dim_product.product_id = sil_production.product_id
        qualify row_number() over (
            partition by
                sil_production.work_order_id
                , sil_production.product_id
            order by sil_production.product_id
        ) = 1
    )

select *
from fct_production