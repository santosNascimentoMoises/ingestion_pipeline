
with currency_rate as (
    select
        AverageRate
        , CurrencyRateDate
        , CurrencyRateID
        , EndOfDayRate
        , FromCurrencyCode
        , ModifiedDate
        , ToCurrencyCode
        , load_at
    from {{ source('raw', 'currency_rate') }}
    )

select *
from currency_rate
