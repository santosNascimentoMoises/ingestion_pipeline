"""Stream type classes for tap_adventureworksapi."""

from __future__ import annotations

import typing as t
from importlib import resources

from singer_sdk import typing as th  # JSON Schema typing helpers

from tap_adventureworksapi.client import AdventureWorksApiStream#, SalesAdventureWorksApiStream

# TODO: Delete this is if not using json files for schema definition
SCHEMAS_DIR = resources.files(__package__) / "schemas"
# TODO: - Override `UsersStream` and `GroupsStream` with your own stream definition.
#       - Copy-paste as many times as needed to create multiple stream types.


class SalesOrderDetail(AdventureWorksApiStream): # nome da stream = endpoint a ser extraido
    """Define custom stream."""

    name = "SalesOrderDetail"  # nome do endpoint
    path = "/SalesOrderDetail" # pasta do endpoint
    primary_keys: t.ClassVar[list[str]] = ['SalesOrderID', 'SalesOrderDetailID']
    replication_key = 'SalesOrderDetailID'
    # Optionally, you may also use `schema_filepath` in place of `schema`:
    schema_filepath = SCHEMAS_DIR / "sales_order_detail.json"  # noqa: ERA001              # referenciar ao schema criado

class SalesOrderHeader(AdventureWorksApiStream): # nome da stream = endpoint a ser extraido
    """Define custom stream."""

    name = "SalesOrderHeader"  # nome do endpoint
    path = "/SalesOrderHeader" # pasta do endpoint
    primary_keys: t.ClassVar[list[str]] = ['SalesOrderID']
    replication_key = 'ModifiedDate'
    # Optionally, you may also use `schema_filepath` in place of `schema`:
    schema_filepath = SCHEMAS_DIR / "sales_order_header.json"  # noqa: ERA001              # referenciar ao schema criado

class PurchaseOrderDetail(AdventureWorksApiStream): # nome da stream = endpoint a ser extraido
    """Define custom stream."""

    name = "PurchaseOrderDetail"  # nome do endpoint
    path = "/PurchaseOrderDetail" # pasta do endpoint
    primary_keys: t.ClassVar[list[str]] = ['PurchaseOrderID']
    replication_key = 'ModifiedDate'
    # Optionally, you may also use `schema_filepath` in place of `schema`:
    schema_filepath = SCHEMAS_DIR / "purchase_order_detail.json"  # noqa: ERA001              # referenciar ao schema criado

class PurchaseOrderHeader(AdventureWorksApiStream): # nome da stream = endpoint a ser extraido
    """Define custom stream."""

    name = "PurchaseOrderHeader"  # nome do endpoint
    path = "/PurchaseOrderHeader" # pasta do endpoint
    primary_keys: t.ClassVar[list[str]] = ['PurchaseOrderID']
    replication_key = 'ModifiedDate'
    # Optionally, you may also use `schema_filepath` in place of `schema`:
    schema_filepath = SCHEMAS_DIR / "purchase_order_header.json"  # noqa: ERA001              # referenciar ao schema criado
