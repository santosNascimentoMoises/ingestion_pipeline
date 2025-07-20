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
            substring_index(BusinessEntityID, '.', 1) as business_entity_id
            , EmailPromotion as email_promotion
            , Demographics::string as demographics
            , FirstName::string as first_name
            , LastName::string as last_name
            , MiddleName::string as middle_name
            , PersonType::string as person_type
            , Suffix::string as suffix
            , Title::string as title
            , load_at::timestamp as load_at
        from person
    )

select *
from renamed
