with
    business_entity as (
        select
            BusinessEntityID
            , ModifiedDate
            , rowguid
            , load_at
    from `adventure_works`.`raw`.`business_entity`
    )

    , renamed as (
        select
            BusinessEntityID as business_entity_id
            , load_at::timestamp as load_at
        from business_entity
    )

select *
from renamed