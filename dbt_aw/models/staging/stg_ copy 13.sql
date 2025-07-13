
with  as (

    from {{ source('raw', '') }}
    )

select *
from 
