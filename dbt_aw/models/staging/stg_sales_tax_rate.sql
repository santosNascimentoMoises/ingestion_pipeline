
with sales_tax_rate as (
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

select *
from sales_tax_rate
