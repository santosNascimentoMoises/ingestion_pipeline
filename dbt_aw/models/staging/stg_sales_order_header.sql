
with sales_order_header as (
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
    )

select *
from sales_order_header
