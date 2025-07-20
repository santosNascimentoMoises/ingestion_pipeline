with  __dbt__cte__stg_currency_rate as (
with
    currency_rate as (
        select
            AverageRate
            , CurrencyRateDate
            , CurrencyRateID
            , EndOfDayRate
            , FromCurrencyCode
            , ModifiedDate
            , ToCurrencyCode
            , load_at
        from `adventure_works`.`bronze`.`currency_rate`
    )

    , renamed as (
        select
            AverageRate::float as average_rate
            , from_unixtime(cast(CurrencyRateDate as bigint) / 1000)::timestamp as currency_rate_date
            , CurrencyRateID::int as currency_rate_id
            , EndOfDayRate::float as end_of_day_rate
            , FromCurrencyCode::string as from_currency_code
            , from_unixtime(cast(ModifiedDate as bigint) / 1000)::timestamp as modified_date
            , ToCurrencyCode::string as to_currency_code
            , load_at::timestamp as load_at
        from currency_rate
    )

select *
from renamed
), base as (
    select *
    from __dbt__cte__stg_currency_rate
)

select * from base