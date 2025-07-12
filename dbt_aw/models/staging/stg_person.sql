
with person as (
    select
        AdditionalContactInfo
        , BusinessEntityID
        , Demographics
        , EmailPromotion
        , FirstName
        , LastName
        , MiddleName
        , ModifiedDate
        , NameStyle
        , PersonType
        , Suffix
        , Title
        , rowguid
        , load_at
    from {{ source('raw', 'person') }}
    )

select *
from 
