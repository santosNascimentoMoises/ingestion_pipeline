with
    stg_customer as (
        select
            customer_id
            , person_id
            , territory_id
        from {{ ref('stg_customer') }}
    )

    , stg_person as (
        select
            business_entity_id
        from {{ ref('stg_person') }}
    )

    , stg_business_entity as (
        select
            business_entity_id
        from {{ ref('stg_business_entity') }}
    )

    , stg_business_entity_address as (
        select
            address_id
            , address_type_id
            , business_entity_id
        from {{ ref('stg_business_entity_address') }}
    )

    , stg_address as (
        select
            address_id
            , address_line1
            , address_line2
            , city
            , postal_code
            , state_province_id
        from {{ ref('stg_address') }}
    )

    , stg_state_province as (
        select
            country_region_code
            , is_only_state_province_flag
            , country_region_name
            , state_province_code
            , state_province_id
            , territory_id
        from {{ ref('stg_state_province') }}
    )

    , stg_country_region as (
        select
            country_region_code
            , country_name
        from {{ ref('stg_country_region') }}
    )

    , customer_person_joined as (
        select
            stg_customer.customer_id
            , stg_customer.person_id
            , stg_customer.territory_id
            
            , stg_person.business_entity_id

        from stg_person
        left join stg_customer
            on stg_customer.person_id = stg_person.business_entity_id

    )

    , intermediate_address as (
        select
            stg_business_entity_address.address_id
            , stg_business_entity_address.address_type_id
            , stg_business_entity_address.business_entity_id
            , stg_address.address_line1
            , stg_address.address_line2
            , stg_address.city
            , stg_address.postal_code
            , stg_address.state_province_id

            , stg_state_province.country_region_code
            , stg_state_province.is_only_state_province_flag
            , stg_state_province.country_region_name
            , stg_state_province.state_province_code

            , stg_country_region.country_name
        from stg_business_entity_address
        left join stg_address
            on stg_business_entity_address.address_id = stg_address.address_id
        left join stg_state_province
            on stg_address.state_province_id = stg_state_province.state_province_id
        left join stg_country_region
            on stg_state_province.country_region_code = stg_country_region.country_region_code
    )

    , final_joined as (
        select
            customer_person_joined.customer_id
            , customer_person_joined.person_id
            , customer_person_joined.territory_id
            , customer_person_joined.business_entity_id

            , intermediate_address.country_region_code
            , intermediate_address.is_only_state_province_flag
            , intermediate_address.country_region_name
            , intermediate_address.state_province_code
            , intermediate_address.country_name

            , intermediate_address.address_id
            , intermediate_address.address_type_id
            , intermediate_address.address_line1
            , intermediate_address.address_line2
            , intermediate_address.city
            , intermediate_address.postal_code
            , intermediate_address.state_province_id
        from customer_person_joined
        left join intermediate_address
            on customer_person_joined.business_entity_id = intermediate_address.business_entity_id
    )

select *
from final_joined
