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
            , substring_index(BillToAddressID, '.', 1) as bill_to_address_id
            , Comment::string as comment
            , CreditCardApprovalCode::string as credit_card_approval_code
            , substring_index(CreditCardID, '.', 1) as credit_card_id
            , substring_index(CurrencyRateID, '.', 1) as currency_rate_id
            , substring_index(CustomerID, '.', 1) as customer_id
            , DueDate as due_date
            , Freight::float as freight
            , OnlineOrderFlag::string as online_order_flag
            , OrderDate as order_date
            , PurchaseOrderNumber::string as purchase_order_number
            , substring_index(RevisionNumber, '.', 1) as revision_number
            , substring_index(SalesOrderID, '.', 1) as sales_order_id
            , SalesOrderNumber::string as sales_order_number
            , substring_index(SalesPersonID, '.', 1) as sales_person_id
            , ShipDate as ship_date
            , substring_index(ShipMethodID, '.', 1) as ship_method_id
            , substring_index(ShipToAddressID, '.', 1) as ship_to_address_id
            , substring_index(Status, '.', 1) as sales_status
            , SubTotal::float as sub_total
            , TaxAmt::float as tax_amt
            , substring_index(TerritoryID, '.', 1) as territory_id
            , TotalDue::float as total_duenumer
            , load_at::timestamp as load_at
        from sales_order_header
    )

select *
from renamed
