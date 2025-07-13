tabela: address
select
    AddressID as address_id
    , AddressLine1 as address_line1
    , AddressLine2 as address_line2
    , City as city
    , ModifiedDate as modified_date
    , PostalCode as postal_code
    , StateProvinceID as state_province_id
    , rowguid as rowguid
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: address_type
select
    AddressTypeID as address_type_id
    , ModifiedDate as modified_date
    , Name as name
    , rowguid as rowguid
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: business_entity
select
    BusinessEntityID as business_entity_id
    , ModifiedDate as modified_date
    , rowguid as rowguid
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: business_entity_address
select
    AddressID as address_id
    , AddressTypeID as address_type_id
    , BusinessEntityID as business_entity_id
    , ModifiedDate as modified_date
    , rowguid as rowguid
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: business_entity_contact
select
    BusinessEntityID as business_entity_id
    , ContactTypeID as contact_type_id
    , ModifiedDate as modified_date
    , PersonID as person_id
    , rowguid as rowguid
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: contact_type
select
    ContactTypeID as contact_type_id
    , ModifiedDate as modified_date
    , Name as name
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: country_region
select
    CountryRegionCode as country_region_code
    , ModifiedDate as modified_date
    , Name as name
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: country_region_currency
select
    CountryRegionCode as country_region_code
    , CurrencyCode as currency_code
    , ModifiedDate as modified_date
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: credit_card
select
    CardNumber as card_number
    , CardType as card_type
    , CreditCardID as credit_card_id
    , ExpMonth as exp_month
    , ExpYear as exp_year
    , ModifiedDate as modified_date
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: culture
select
    CultureID as culture_id
    , ModifiedDate as modified_date
    , Name as name
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: currency
select
    CurrencyCode as currency_code
    , ModifiedDate as modified_date
    , Name as name
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: currency_rate
select
    AverageRate as average_rate
    , CurrencyRateDate as currency_rate_date
    , CurrencyRateID as currency_rate_id
    , EndOfDayRate as end_of_day_rate
    , FromCurrencyCode as from_currency_code
    , ModifiedDate as modified_date
    , ToCurrencyCode as to_currency_code
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: customer
select
    AccountNumber as account_number
    , CustomerID as customer_id
    , ModifiedDate as modified_date
    , PersonID as person_id
    , StoreID as store_id
    , TerritoryID as territory_id
    , rowguid as rowguid
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: department
select
    DepartmentID as department_id
    , GroupName as group_name
    , ModifiedDate as modified_date
    , Name as name
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: email_address
select
    BusinessEntityID as business_entity_id
    , EmailAddress as email_address
    , EmailAddressID as email_address_id
    , ModifiedDate as modified_date
    , rowguid as rowguid
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: employee
select
    BirthDate as birth_date
    , BusinessEntityID as business_entity_id
    , CurrentFlag as current_flag
    , Gender as gender
    , HireDate as hire_date
    , JobTitle as job_title
    , LoginID as login_id
    , MaritalStatus as marital_status
    , ModifiedDate as modified_date
    , NationalIDNumber as national_id_number
    , OrganizationLevel as organization_level
    , SalariedFlag as salaried_flag
    , SickLeaveHours as sick_leave_hours
    , VacationHours as vacation_hours
    , rowguid as rowguid
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: location
select
    Availability as availability
    , CostRate as cost_rate
    , LocationID as location_id
    , ModifiedDate as modified_date
    , Name as name
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: person
select
    AdditionalContactInfo as additional_contact_info
    , BusinessEntityID as business_entity_id
    , Demographics as demographics
    , EmailPromotion as email_promotion
    , FirstName as first_name
    , LastName as last_name
    , MiddleName as middle_name
    , ModifiedDate as modified_date
    , NameStyle as name_style
    , PersonType as person_type
    , Suffix as suffix
    , Title as title
    , rowguid as rowguid
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: person_credit_card
select
    BusinessEntityID as business_entity_id
    , CreditCardID as credit_card_id
    , ModifiedDate as modified_date
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: person_phone
select
    BusinessEntityID as business_entity_id
    , ModifiedDate as modified_date
    , PhoneNumber as phone_number
    , PhoneNumberTypeID as phone_number_type_id
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: phone_number_type
select
    ModifiedDate as modified_date
    , Name as name
    , PhoneNumberTypeID as phone_number_type_id
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: product
select
    Class as class
    , Color as color
    , DaysToManufacture as days_to_manufacture
    , DiscontinuedDate as discontinued_date
    , FinishedGoodsFlag as finished_goods_flag
    , ListPrice as list_price
    , MakeFlag as make_flag
    , ModifiedDate as modified_date
    , Name as name
    , ProductID as product_id
    , ProductLine as product_line
    , ProductModelID as product_model_id
    , ProductNumber as product_number
    , ProductSubcategoryID as product_subcategory_id
    , ReorderPoint as reorder_point
    , SafetyStockLevel as safety_stock_level
    , SellEndDate as sell_end_date
    , SellStartDate as sell_start_date
    , Size as size
    , SizeUnitMeasureCode as size_unit_measure_code
    , StandardCost as standard_cost
    , Style as style
    , Weight as weight
    , WeightUnitMeasureCode as weight_unit_measure_code
    , rowguid as rowguid
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: product_category
select
    ModifiedDate as modified_date
    , Name as name
    , ProductCategoryID as product_category_id
    , rowguid as rowguid
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: product_cost_history
select
    EndDate as end_date
    , ModifiedDate as modified_date
    , ProductID as product_id
    , StandardCost as standard_cost
    , StartDate as start_date
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: product_inventory
select
    Bin as bin
    , LocationID as location_id
    , ModifiedDate as modified_date
    , ProductID as product_id
    , Quantity as quantity
    , Shelf as shelf
    , rowguid as rowguid
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: product_list_price_history
select
    EndDate as end_date
    , ListPrice as list_price
    , ModifiedDate as modified_date
    , ProductID as product_id
    , StartDate as start_date
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: product_model
select
    CatalogDescription as catalog_description
    , Instructions as instructions
    , ModifiedDate as modified_date
    , Name as name
    , ProductModelID as product_model_id
    , rowguid as rowguid
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: product_model_product_description_culture
select
    CultureID as culture_id
    , ModifiedDate as modified_date
    , ProductDescriptionID as product_description_id
    , ProductModelID as product_model_id
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: product_subcategory
select
    ModifiedDate as modified_date
    , Name as name
    , ProductCategoryID as product_category_id
    , ProductSubcategoryID as product_subcategory_id
    , rowguid as rowguid
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: product_vendor
select
    AverageLeadTime as average_lead_time
    , BusinessEntityID as business_entity_id
    , LastReceiptCost as last_receipt_cost
    , LastReceiptDate as last_receipt_date
    , MaxOrderQty as max_order_qty
    , MinOrderQty as min_order_qty
    , ModifiedDate as modified_date
    , OnOrderQty as on_order_qty
    , ProductID as product_id
    , StandardPrice as standard_price
    , UnitMeasureCode as unit_measure_code
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: purchase_order_detail
select
    DueDate as due_date
    , LineTotal as line_total
    , ModifiedDate as modified_date
    , OrderQty as order_qty
    , ProductID as product_id
    , PurchaseOrderDetailID as purchase_order_detail_id
    , PurchaseOrderID as purchase_order_id
    , ReceivedQty as received_qty
    , RejectedQty as rejected_qty
    , StockedQty as stocked_qty
    , UnitPrice as unit_price
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: purchase_order_header
select
    EmployeeID as employee_id
    , Freight as freight
    , ModifiedDate as modified_date
    , OrderDate as order_date
    , PurchaseOrderID as purchase_order_id
    , RevisionNumber as revision_number
    , ShipDate as ship_date
    , ShipMethodID as ship_method_id
    , Status as status
    , SubTotal as sub_total
    , TaxAmt as tax_amt
    , TotalDue as total_due
    , VendorID as vendor_id
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: sales_order_detail
select
    CarrierTrackingNumber as carrier_tracking_number
    , LineTotal as line_total
    , ModifiedDate as modified_date
    , OrderQty as order_qty
    , ProductID as product_id
    , SalesOrderDetailID as sales_order_detail_id
    , SalesOrderID as sales_order_id
    , SpecialOfferID as special_offer_id
    , UnitPrice as unit_price
    , UnitPriceDiscount as unit_price_discount
    , rowguid as rowguid
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: sales_order_header
select
    AccountNumber as account_number
    , BillToAddressID as bill_to_address_id
    , Comment as comment
    , CreditCardApprovalCode as credit_card_approval_code
    , CreditCardID as credit_card_id
    , CurrencyRateID as currency_rate_id
    , CustomerID as customer_id
    , DueDate as due_date
    , Freight as freight
    , ModifiedDate as modified_date
    , OnlineOrderFlag as online_order_flag
    , OrderDate as order_date
    , PurchaseOrderNumber as purchase_order_number
    , RevisionNumber as revision_number
    , SalesOrderID as sales_order_id
    , SalesOrderNumber as sales_order_number
    , SalesPersonID as sales_person_id
    , ShipDate as ship_date
    , ShipMethodID as ship_method_id
    , ShipToAddressID as ship_to_address_id
    , Status as status
    , SubTotal as sub_total
    , TaxAmt as tax_amt
    , TerritoryID as territory_id
    , TotalDue as total_due
    , rowguid as rowguid
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: sales_order_header_sales_reason
select
    ModifiedDate as modified_date
    , SalesOrderID as sales_order_id
    , SalesReasonID as sales_reason_id
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: sales_person
select
    Bonus as bonus
    , BusinessEntityID as business_entity_id
    , CommissionPct as commission_pct
    , ModifiedDate as modified_date
    , SalesLastYear as sales_last_year
    , SalesQuota as sales_quota
    , SalesYTD as sales_ytd
    , TerritoryID as territory_id
    , rowguid as rowguid
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: sales_person_quota_history
select
    BusinessEntityID as business_entity_id
    , ModifiedDate as modified_date
    , QuotaDate as quota_date
    , SalesQuota as sales_quota
    , rowguid as rowguid
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: sales_reason
select
    ModifiedDate as modified_date
    , Name as name
    , ReasonType as reason_type
    , SalesReasonID as sales_reason_id
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: sales_tax_rate
select
    ModifiedDate as modified_date
    , Name as name
    , SalesTaxRateID as sales_tax_rate_id
    , StateProvinceID as state_province_id
    , TaxRate as tax_rate
    , TaxType as tax_type
    , rowguid as rowguid
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: sales_territory
select
    CostLastYear as cost_last_year
    , CostYTD as cost_ytd
    , CountryRegionCode as country_region_code
    , Group as group
    , ModifiedDate as modified_date
    , Name as name
    , SalesLastYear as sales_last_year
    , SalesYTD as sales_ytd
    , TerritoryID as territory_id
    , rowguid as rowguid
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: sales_territory_history
select
    BusinessEntityID as business_entity_id
    , EndDate as end_date
    , ModifiedDate as modified_date
    , StartDate as start_date
    , TerritoryID as territory_id
    , rowguid as rowguid
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: scrap_reason
select
    ModifiedDate as modified_date
    , Name as name
    , ScrapReasonID as scrap_reason_id
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: ship_method
select
    ModifiedDate as modified_date
    , Name as name
    , ShipBase as ship_base
    , ShipMethodID as ship_method_id
    , ShipRate as ship_rate
    , rowguid as rowguid
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: shopping_cart_item
select
    DateCreated as date_created
    , ModifiedDate as modified_date
    , ProductID as product_id
    , Quantity as quantity
    , ShoppingCartID as shopping_cart_id
    , ShoppingCartItemID as shopping_cart_item_id
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: special_offer
select
    Category as category
    , Description as description
    , DiscountPct as discount_pct
    , EndDate as end_date
    , MaxQty as max_qty
    , MinQty as min_qty
    , ModifiedDate as modified_date
    , SpecialOfferID as special_offer_id
    , StartDate as start_date
    , Type as type
    , rowguid as rowguid
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: special_offer_product
select
    ModifiedDate as modified_date
    , ProductID as product_id
    , SpecialOfferID as special_offer_id
    , rowguid as rowguid
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: state_province
select
    CountryRegionCode as country_region_code
    , IsOnlyStateProvinceFlag as is_only_state_province_flag
    , ModifiedDate as modified_date
    , Name as name
    , StateProvinceCode as state_province_code
    , StateProvinceID as state_province_id
    , TerritoryID as territory_id
    , rowguid as rowguid
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: store
select
    BusinessEntityID as business_entity_id
    , Demographics as demographics
    , ModifiedDate as modified_date
    , Name as name
    , SalesPersonID as sales_person_id
    , rowguid as rowguid
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: transaction_history
select
    ActualCost as actual_cost
    , ModifiedDate as modified_date
    , ProductID as product_id
    , Quantity as quantity
    , ReferenceOrderID as reference_order_id
    , ReferenceOrderLineID as reference_order_line_id
    , TransactionDate as transaction_date
    , TransactionID as transaction_id
    , TransactionType as transaction_type
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: transaction_history_archive
select
    ActualCost as actual_cost
    , ModifiedDate as modified_date
    , ProductID as product_id
    , Quantity as quantity
    , ReferenceOrderID as reference_order_id
    , ReferenceOrderLineID as reference_order_line_id
    , TransactionDate as transaction_date
    , TransactionID as transaction_id
    , TransactionType as transaction_type
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: vendor
select
    AccountNumber as account_number
    , ActiveFlag as active_flag
    , BusinessEntityID as business_entity_id
    , CreditRating as credit_rating
    , ModifiedDate as modified_date
    , Name as name
    , PreferredVendorStatus as preferred_vendor_status
    , PurchasingWebServiceURL as purchasing_web_service_url
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: work_order
select
    DueDate as due_date
    , EndDate as end_date
    , ModifiedDate as modified_date
    , OrderQty as order_qty
    , ProductID as product_id
    , ScrapReasonID as scrap_reason_id
    , ScrappedQty as scrapped_qty
    , StartDate as start_date
    , StockedQty as stocked_qty
    , WorkOrderID as work_order_id
    , load_at as load_at
from {{ source('', '') }}

___________________

tabela: work_order_routing
select
    ActualCost as actual_cost
    , ActualEndDate as actual_end_date
    , ActualResourceHrs as actual_resource_hrs
    , ActualStartDate as actual_start_date
    , LocationID as location_id
    , ModifiedDate as modified_date
    , OperationSequence as operation_sequence
    , PlannedCost as planned_cost
    , ProductID as product_id
    , ScheduledEndDate as scheduled_end_date
    , ScheduledStartDate as scheduled_start_date
    , WorkOrderID as work_order_id
    , load_at as load_at
from {{ source('', '') }}