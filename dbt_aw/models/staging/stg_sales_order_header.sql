with
    sales_order_header as (
        select
            AccountNumber
            , BillToAddressID
            , Comment
            , CreditCardApprovalCode
            , CreditCardID
            , CurrencyRateID
            , CustomerID
            , DueDate
            , Freight
            , ModifiedDate
            , OnlineOrderFlag
            , OrderDate
            , PurchaseOrderNumber
            , RevisionNumber
            , SalesOrderID
            , SalesOrderNumber
            , SalesPersonID
            , ShipDate
            , ShipMethodID
            , ShipToAddressID
            , Status
            , SubTotal
            , TaxAmt
            , TerritoryID
            , TotalDue
            , rowguid
            , load_at
        from {{ source('raw','sales_order_header') }}    
    )

    , renamed as (
        select
            AccountNumber::string as account_number
            , BillToAddressID::int as bill_to_address_id
            , Comment::string as comment
            , CreditCardApprovalCode::string as credit_card_approval_code
            , CreditCardID::int as credit_card_id
            , CurrencyRateID::int as currency_rate_id
            , CustomerID::int as customer_id
            , from_unixtime(cast(DueDate as bigint) / 1000)::timestamp as due_date
            , Freight::float as freight
            , from_unixtime(cast(ModifiedDate as bigint) / 1000)::timestamp as modified_date
            , OnlineOrderFlag::string as online_order_flag
            , from_unixtime(cast(OrderDate as bigint) / 1000)::timestamp as order_date
            , PurchaseOrderNumber::string as purchase_order_number
            , RevisionNumber::int as revision_number
            , SalesOrderID::int as sales_order_id
            , SalesOrderNumber::string as sales_order_number
            , SalesPersonID::int as sales_person_id
            , from_unixtime(cast(ShipDate as bigint) / 1000)::timestamp as ship_date
            , ShipMethodID::int as ship_method_id
            , ShipToAddressID::int as ship_to_address_id
            , Status::int as sales_status
            , SubTotal::number as sub_total
            , TaxAmt::number as tax_amt
            , TerritoryID::int as territory_id
            , TotalDue::float as total_duenumer
            , load_at::timestamp as load_at
        from sales_order_header
    )

select *
from renamed
