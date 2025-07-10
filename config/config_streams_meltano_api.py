
# CONFIG DATABRICKS PATHS: VOLUME DE DESTIDO DOS DADOS BRUTOS
RAW_API_VOLUME_PATH = 'dbfs:/Volumes/adventure_works/raw/raw_api/'

# CONFIGS FROM API MELTANO EXTRACT
# type of the data ouput - ex: .json, .parquet WITH POINT
DATA_TYPE_EXTRACT_API = ".jsonl"

EXTRACT_STREAM_INDICATOR = {
    'SalesOrderHeader':True,
    'SalesOrderDetail':True,
    'PurchaseOrderDetail':True,
    'PurchaseOrderHeader':True
}

STREAMS_METADATA = {
    "SalesOrderHeader": {
        "path": "/SalesOrderHeader",
        "primary_keys": ["SalesOrderID"],
        "replication_key": "ModifiedDate",
        "schema_filepath": "sales_order_header.json",

        # raw data volume on databricks
        "volume_path": RAW_API_VOLUME_PATH,

        # type of the data ouput - ex: .json, .parquet
        "data_type": DATA_TYPE_EXTRACT_API

    },
    "SalesOrderDetail": {
        "path": "/SalesOrderDetail",
        "primary_keys": ["SalesOrderID", "SalesOrderDetailID"],
        "replication_key": "SalesOrderDetailID",
        "schema_filepath": "sales_order_detail.json",

        # raw data volume on databricks
        "volume_path": RAW_API_VOLUME_PATH,

        # type of the data ouput - ex: .json
        "data_type": DATA_TYPE_EXTRACT_API
    },
    "PurchaseOrderDetail": {
        "path": "/PurchaseOrderDetail",
        "primary_keys": ["PurchaseOrderID"],
        "replication_key": "ModifiedDate",
        "schema_filepath": "purchase_order_detail.json",

        # raw data volume on databricks
        "volume_path": RAW_API_VOLUME_PATH,

        # type of the data ouput - ex: .json
        "data_type": DATA_TYPE_EXTRACT_API
    },
    "PurchaseOrderHeader": {
        "path": "/PurchaseOrderHeader",
        "primary_keys": ["PurchaseOrderID"],
        "replication_key": "ModifiedDate",
        "schema_filepath": "purchase_order_header.json",

        # raw data volume on databricks
        "volume_path": RAW_API_VOLUME_PATH,

        # type of the data ouput - ex: .json
        "data_type": DATA_TYPE_EXTRACT_API
    },
}

def get_streams_select():
    return {
        name: metadata
        for name, metadata in STREAMS_METADATA.items()
        if EXTRACT_STREAM_INDICATOR.get(name, False)
    }

teste = get_streams_select()
print(teste)
