
with
    location_raw as (
        select
            Availability as location_availability
            , CostRate as cost_rate
            , LocationID as location_id
            , ModifiedDate as modified_date
            , Name as location_name
            , load_at
        from {{ source('raw', 'location') }}
    )

    , renamed as (
        select
            substring_index(location_availability, '.', 1)::int as location_availability
            , cost_rate::float as cost_rate
            , substring_index(location_id, '.', 1) as location_id
            , from_unixtime(cast(ModifiedDate as bigint) / 1000)::timestamp as modified_date
            , location_name::string location_name
            , load_at::timestamp load_at
        from location_raw
    )

select *
from renamed
