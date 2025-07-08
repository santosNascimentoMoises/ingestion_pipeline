

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
        "schema_filepath": "sales_order_header.json"
    },
    "SalesOrderDetail": {
        "path": "/SalesOrderDetail",
        "primary_keys": ["SalesOrderID", "SalesOrderDetailID"],
        "replication_key": "SalesOrderDetailID",
        "schema_filepath": "sales_order_detail.json"
    },
    "PurchaseOrderDetail": {
        "path": "/PurchaseOrderDetail",
        "primary_keys": ["PurchaseOrderID"],
        "replication_key": "ModifiedDate",
        "schema_filepath": "purchase_order_detail.json"
    },
    "PurchaseOrderHeader": {
        "path": "/PurchaseOrderHeader",
        "primary_keys": ["PurchaseOrderID"],
        "replication_key": "ModifiedDate",
        "schema_filepath": "purchase_order_header.json"
    },
}

# def get_streams_select():
#     STREAMS_TO_EXTRACT = {}
#     for name, metadata in STREAMS_METADATA.items():
#         if EXTRACT_STREAM_INDICATOR[name]:
#             STREAMS_TO_EXTRACT[name] = metadata

#     return(STREAMS_TO_EXTRACT)

# if __name__ == "__main__":
#     get_streams_select()

def get_streams_select():
    return {
        name: metadata
        for name, metadata in STREAMS_METADATA.items()
        if EXTRACT_STREAM_INDICATOR.get(name, False)
    }
