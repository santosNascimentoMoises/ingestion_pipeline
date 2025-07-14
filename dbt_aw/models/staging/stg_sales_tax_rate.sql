with 
    sales_tax_rate as (
        select
            ModifiedDate
            , Name
            , SalesTaxRateID
            , StateProvinceID
            , TaxRate
            , TaxType
            , rowguid
            , load_at
        from {{ source('raw', 'sales_tax_rate') }}
    )

    , renamed as (
        select
            from_unixtime(cast(ModifiedDate as bigint) / 1000)::timestamp as modified_date
            , Name::string as tax_rate_name
            , SalesTaxRateID::int as sales_tax_rate_id
            , StateProvinceID::int as state_province_id
            , TaxRate::float as tax_rate
            , TaxType::int as tax_type
            , load_at::timestamp as load_at
        from sales_tax_rate
    )

select *
from renamed
