tabela: address
select
    AddressID
    , AddressLine1
    , AddressLine2
    , City
    , ModifiedDate
    , PostalCode
    , StateProvinceID
    , rowguid
    , load_at
from {{ source('', '') }}

___________________

tabela: address_type
select
    AddressTypeID
    , ModifiedDate
    , Name
    , rowguid
    , load_at
from {{ source('', '') }}

___________________

tabela: business_entity
select
    BusinessEntityID
    , ModifiedDate
    , rowguid
    , load_at
from {{ source('', '') }}

___________________

tabela: business_entity_address
select
    AddressID
    , AddressTypeID
    , BusinessEntityID
    , ModifiedDate
    , rowguid
    , load_at
from {{ source('', '') }}

___________________

tabela: business_entity_contact
select
    BusinessEntityID
    , ContactTypeID
    , ModifiedDate
    , PersonID
    , rowguid
    , load_at
from {{ source('', '') }}

___________________

tabela: contact_type
select
    ContactTypeID
    , ModifiedDate
    , Name
    , load_at
from {{ source('', '') }}

___________________

tabela: country_region
select
    CountryRegionCode
    , ModifiedDate
    , Name
    , load_at
from {{ source('', '') }}

___________________

tabela: country_region_currency
select
    CountryRegionCode
    , CurrencyCode
    , ModifiedDate
    , load_at
from {{ source('', '') }}

___________________

tabela: credit_card
select
    CardNumber
    , CardType
    , CreditCardID
    , ExpMonth
    , ExpYear
    , ModifiedDate
    , load_at
from {{ source('', '') }}

___________________

tabela: culture
select
    CultureID
    , ModifiedDate
    , Name
    , load_at
from {{ source('', '') }}

___________________

tabela: currency
select
    CurrencyCode
    , ModifiedDate
    , Name
    , load_at
from {{ source('', '') }}

___________________

tabela: currency_rate
select
    AverageRate
    , CurrencyRateDate
    , CurrencyRateID
    , EndOfDayRate
    , FromCurrencyCode
    , ModifiedDate
    , ToCurrencyCode
    , load_at
from {{ source('', '') }}

___________________

tabela: customer x
select
    AccountNumber
    , CustomerID
    , ModifiedDate
    , PersonID
    , StoreID
    , TerritoryID
    , rowguid
    , load_at
from {{ source('', '') }}

___________________

tabela: department
select
    DepartmentID
    , GroupName
    , ModifiedDate
    , Name
    , load_at
from {{ source('', '') }}

___________________

tabela: email_address
select
    BusinessEntityID
    , EmailAddress
    , EmailAddressID
    , ModifiedDate
    , rowguid
    , load_at
from {{ source('', '') }}

___________________

tabela: employee
select
    BirthDate
    , BusinessEntityID
    , CurrentFlag
    , Gender
    , HireDate
    , JobTitle
    , LoginID
    , MaritalStatus
    , ModifiedDate
    , NationalIDNumber
    , OrganizationLevel
    , SalariedFlag
    , SickLeaveHours
    , VacationHours
    , rowguid
    , load_at
from {{ source('', '') }}

___________________

tabela: location
select
    Availability
    , CostRate
    , LocationID
    , ModifiedDate
    , Name
    , load_at
from {{ source('', '') }}

___________________

tabela: person
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
from {{ source('', '') }}

___________________

tabela: person_credit_card
select
    BusinessEntityID
    , CreditCardID
    , ModifiedDate
    , load_at
from {{ source('', '') }}

___________________

tabela: person_phone
select
    BusinessEntityID
    , ModifiedDate
    , PhoneNumber
    , PhoneNumberTypeID
    , load_at
from {{ source('', '') }}

___________________

tabela: phone_number_type
select
    ModifiedDate
    , Name
    , PhoneNumberTypeID
    , load_at
from {{ source('', '') }}

___________________

tabela: product
select
    Class
    , Color
    , DaysToManufacture
    , DiscontinuedDate
    , FinishedGoodsFlag
    , ListPrice
    , MakeFlag
    , ModifiedDate
    , Name
    , ProductID
    , ProductLine
    , ProductModelID
    , ProductNumber
    , ProductSubcategoryID
    , ReorderPoint
    , SafetyStockLevel
    , SellEndDate
    , SellStartDate
    , Size
    , SizeUnitMeasureCode
    , StandardCost
    , Style
    , Weight
    , WeightUnitMeasureCode
    , rowguid
    , load_at
from {{ source('', '') }}

___________________

tabela: product_category
select
    ModifiedDate
    , Name
    , ProductCategoryID
    , rowguid
    , load_at
from {{ source('', '') }}

___________________

tabela: product_cost_history
select
    EndDate
    , ModifiedDate
    , ProductID
    , StandardCost
    , StartDate
    , load_at
from {{ source('', '') }}

___________________

tabela: product_inventory
select
    Bin
    , LocationID
    , ModifiedDate
    , ProductID
    , Quantity
    , Shelf
    , rowguid
    , load_at
from {{ source('', '') }}

___________________

tabela: product_list_price_history
select
    EndDate
    , ListPrice
    , ModifiedDate
    , ProductID
    , StartDate
    , load_at
from {{ source('', '') }}

___________________

tabela: product_model
select
    CatalogDescription
    , Instructions
    , ModifiedDate
    , Name
    , ProductModelID
    , rowguid
    , load_at
from {{ source('', '') }}

___________________

tabela: product_model_product_description_culture
select
    CultureID
    , ModifiedDate
    , ProductDescriptionID
    , ProductModelID
    , load_at
from {{ source('', '') }}

___________________

tabela: product_subcategory
select
    ModifiedDate
    , Name
    , ProductCategoryID
    , ProductSubcategoryID
    , rowguid
    , load_at
from {{ source('', '') }}

___________________

tabela: product_vendor
select
    AverageLeadTime
    , BusinessEntityID
    , LastReceiptCost
    , LastReceiptDate
    , MaxOrderQty
    , MinOrderQty
    , ModifiedDate
    , OnOrderQty
    , ProductID
    , StandardPrice
    , UnitMeasureCode
    , load_at
from {{ source('', '') }}

___________________

tabela: purchase_order_detail
select
    DueDate
    , LineTotal
    , ModifiedDate
    , OrderQty
    , ProductID
    , PurchaseOrderDetailID
    , PurchaseOrderID
    , ReceivedQty
    , RejectedQty
    , StockedQty
    , UnitPrice
    , load_at
from {{ source('', '') }}

___________________

tabela: purchase_order_header
select
    EmployeeID
    , Freight
    , ModifiedDate
    , OrderDate
    , PurchaseOrderID
    , RevisionNumber
    , ShipDate
    , ShipMethodID
    , Status
    , SubTotal
    , TaxAmt
    , TotalDue
    , VendorID
    , load_at
from {{ source('', '') }}

___________________

tabela: sales_order_detail x
select
    CarrierTrackingNumber
    , LineTotal
    , ModifiedDate
    , OrderQty
    , ProductID
    , SalesOrderDetailID
    , SalesOrderID
    , SpecialOfferID
    , UnitPrice
    , UnitPriceDiscount
    , rowguid
    , load_at
from {{ source('', '') }}

___________________

tabela: sales_order_header x
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
from {{ source('', '') }}

___________________

tabela: sales_order_header_sales_reason
select
    ModifiedDate
    , SalesOrderID
    , SalesReasonID
    , load_at
from {{ source('', '') }}

___________________

tabela: sales_person x
select
    Bonus
    , BusinessEntityID
    , CommissionPct
    , ModifiedDate
    , SalesLastYear
    , SalesQuota
    , SalesYTD
    , TerritoryID
    , rowguid
    , load_at
from {{ source('', '') }}

___________________

tabela: sales_person_quota_history x
select
    BusinessEntityID
    , ModifiedDate
    , QuotaDate
    , SalesQuota
    , rowguid
    , load_at
from {{ source('', '') }}

___________________

tabela: sales_reason x
select
    ModifiedDate
    , Name
    , ReasonType
    , SalesReasonID
    , load_at
from {{ source('', '') }}

___________________

tabela: sales_tax_rate
select
    ModifiedDate
    , Name
    , SalesTaxRateID
    , StateProvinceID
    , TaxRate
    , TaxType
    , rowguid
    , load_at
from {{ source('', '') }}

___________________

tabela: sales_territory x
select
    CostLastYear
    , CostYTD
    , CountryRegionCode
    , Group
    , ModifiedDate
    , Name
    , SalesLastYear
    , SalesYTD
    , TerritoryID
    , rowguid
    , load_at
from {{ source('', '') }}

___________________

tabela: sales_territory_history x
select
    BusinessEntityID
    , EndDate
    , ModifiedDate
    , StartDate
    , TerritoryID
    , rowguid
    , load_at
from {{ source('', '') }}

___________________

tabela: scrap_reason
select
    ModifiedDate
    , Name
    , ScrapReasonID
    , load_at
from {{ source('', '') }}

___________________

tabela: ship_method
select
    ModifiedDate
    , Name
    , ShipBase
    , ShipMethodID
    , ShipRate
    , rowguid
    , load_at
from {{ source('', '') }}

___________________

tabela: shopping_cart_item
select
    DateCreated
    , ModifiedDate
    , ProductID
    , Quantity
    , ShoppingCartID
    , ShoppingCartItemID
    , load_at
from {{ source('', '') }}

___________________

tabela: special_offer
select
    Category
    , Description
    , DiscountPct
    , EndDate
    , MaxQty
    , MinQty
    , ModifiedDate
    , SpecialOfferID
    , StartDate
    , Type
    , rowguid
    , load_at
from {{ source('', '') }}

___________________

tabela: special_offer_product
select
    ModifiedDate
    , ProductID
    , SpecialOfferID
    , rowguid
    , load_at
from {{ source('', '') }}

___________________

tabela: state_province
select
    CountryRegionCode
    , IsOnlyStateProvinceFlag
    , ModifiedDate
    , Name
    , StateProvinceCode
    , StateProvinceID
    , TerritoryID
    , rowguid
    , load_at
from {{ source('', '') }}

___________________

tabela: store
select
    BusinessEntityID
    , Demographics
    , ModifiedDate
    , Name
    , SalesPersonID
    , rowguid
    , load_at
from {{ source('', '') }}

___________________

tabela: transaction_history
select
    ActualCost
    , ModifiedDate
    , ProductID
    , Quantity
    , ReferenceOrderID
    , ReferenceOrderLineID
    , TransactionDate
    , TransactionID
    , TransactionType
    , load_at
from {{ source('', '') }}

___________________

tabela: transaction_history_archive
select
    ActualCost
    , ModifiedDate
    , ProductID
    , Quantity
    , ReferenceOrderID
    , ReferenceOrderLineID
    , TransactionDate
    , TransactionID
    , TransactionType
    , load_at
from {{ source('', '') }}

___________________

tabela: vendor
select
    AccountNumber
    , ActiveFlag
    , BusinessEntityID
    , CreditRating
    , ModifiedDate
    , Name
    , PreferredVendorStatus
    , PurchasingWebServiceURL
    , load_at
from {{ source('', '') }}

___________________

tabela: work_order
select
    DueDate
    , EndDate
    , ModifiedDate
    , OrderQty
    , ProductID
    , ScrapReasonID
    , ScrappedQty
    , StartDate
    , StockedQty
    , WorkOrderID
    , load_at
from {{ source('', '') }}

___________________

tabela: work_order_routing
select
    ActualCost
    , ActualEndDate
    , ActualResourceHrs
    , ActualStartDate
    , LocationID
    , ModifiedDate
    , OperationSequence
    , PlannedCost
    , ProductID
    , ScheduledEndDate
    , ScheduledStartDate
    , WorkOrderID
    , load_at
from {{ source('', '') }}
