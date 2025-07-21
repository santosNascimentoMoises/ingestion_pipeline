
with
    location_raw as (
        select
            Availability
            , CostRate
            , LocationID
            , ModifiedDate
            , Name
            , load_at
        from {{ source('raw', 'location') }}
    )

    , renamed as (
        select
            substring_index(Availability, '.', 1)::int as location_availability
            , CostRate::float as cost_rate
            , substring_index(LocationID, '.', 1) as location_id
            , from_unixtime(cast(ModifiedDate as bigint) / 1000)::timestamp as modified_date
            , Name::string location_name
            , load_at::timestamp load_at
        from location_raw
    )

select *
from renamed
