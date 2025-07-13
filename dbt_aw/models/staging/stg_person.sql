
with
    person as (
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

    , renamed as (
        select
            , BusinessEntityID::int as business_entity_id
            , EmailPromotion::int as email_promotion
            , FirstName::string as first_name
            , LastName::string as last_name
            , MiddleName::string as middle_name
            , ModifiedDate::timestamp as modified_date
            , PersonType::string as person_type
            , Suffix::string as suffix
            , Title::string as title
            , load_at::timestamp as load_at
        from person
    )

select *
from renamed
