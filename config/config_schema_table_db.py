import os
# CONFIG DATABRICKS PATHS: VOLUME DE DESTIDO DOS DADOS BRUTOS
# RAW_DB_VOLUME_PATH = 'dbfs:/Volumes/adventure_works/raw_extract/raw_db/'
RAW_DB_VOLUME_PATH = os.getenv('RAW_DB_VOLUME_PATH')

# CONFIGS FROM DB SPARK EXTRACT
DATA_TYPE_EXTRACT_DB = ".jsonl"

# TESTES:
# EXTRACT_SCHEMA_TABLE_INDICATOR = {

#         "Purchasing": {
#             "ProductVendor": True,
#             "PurchaseOrderDetail": True,
#             "PurchaseOrderHeader": True,
#             "ShipMethod": True,
#             "Vendor": True
#         }
#     }

EXTRACT_SCHEMA_TABLE_INDICATOR = {

        "dbo": {
            "AWBuildVersion": False,
            "DatabaseLog": False,
            "ErrorLog": False
        },
        "HumanResources": {
            "Department": True,
            "Employee": True,
            "EmployeeDepartmentHistory": False,
            "EmployeePayHistory": False,
            "JobCandidate": False,
            "Shift": False
        },
        "Person": {
            "Address": True,
            "AddressType": True,
            "BusinessEntity": True,
            "BusinessEntityAddress": True,
            "BusinessEntityContact": True,
            "ContactType": True,
            "CountryRegion": True,
            "EmailAddress": True,
            "Password": False,
            "Person": True,
            "PersonPhone": True,
            "PhoneNumberType": True,
            "StateProvince": True
        },
        "Production": {
            "BillOfMaterials": False,
            "Culture": True,
            "Document": False,
            "Illustration": False,
            "Location": True,
            "Product": True,
            "ProductCategory": True,
            "ProductCostHistory": True,
            "ProductDescription": False,
            "ProductDocument": False,
            "ProductInventory": True,
            "ProductListPriceHistory": True,
            "ProductModel": True,
            "ProductModelIllustration": False,
            "ProductModelProductDescriptionCulture": True,
            "ProductPhoto": False,
            "ProductProductPhoto": False,
            "ProductReview": False,
            "ProductSubcategory": True,
            "ScrapReason": True,
            "TransactionHistory": True,
            "TransactionHistoryArchive": True,
            "UnitMeasure": False,
            "WorkOrder": True,
            "WorkOrderRouting": True
        },
        "Purchasing": {
            "ProductVendor": True,
            "PurchaseOrderDetail": True,
            "PurchaseOrderHeader": True,
            "ShipMethod": True,
            "Vendor": True
        },
        "Sales": {
            "CountryRegionCurrency": True,
            "CreditCard": True,
            "Currency": True,
            "CurrencyRate": True,
            "Customer": True,
            "PersonCreditCard": True,
            "SalesOrderDetail": True,
            "SalesOrderHeader": True,
            "SalesOrderHeaderSalesReason": True,
            "SalesPerson": True,
            "SalesPersonQuotaHistory": True,
            "SalesReason": True,
            "SalesTaxRate": True,
            "SalesTerritory": True,
            "SalesTerritoryHistory": True,
            "ShoppingCartItem": True,
            "SpecialOffer": True,
            "SpecialOfferProduct": True,
            "Store": True
        }
    }

def get_schema_table_select():
    output = {}

    for schema, tables in EXTRACT_SCHEMA_TABLE_INDICATOR.items():
        for table, flag in tables.items():
            if flag is True:

                metadata = {
                    "name":table,
                    "schema":schema,
                    "data_type":DATA_TYPE_EXTRACT_DB,
                    "volume_path":RAW_DB_VOLUME_PATH,
                }
                output[table] = metadata.copy()

    return output

# # print(get_schema_table_select())