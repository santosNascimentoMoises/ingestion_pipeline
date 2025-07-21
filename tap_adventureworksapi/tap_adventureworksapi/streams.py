"""Stream type classes for tap_adventureworksapi."""

from __future__ import annotations
import typing as t
from importlib import resources
from singer_sdk import typing as th  # JSON Schema typing helpers
from tap_adventureworksapi.client import AdventureWorksApiStream
import os

SCHEMAS_DIR = resources.files(__package__) / "schemas"

name = os.getenv("STREAM_NAME")
path = os.getenv("STREAM_PATH")
primary_keys = os.getenv("STREAM_PK").split(",")
replication_key = os.getenv("REPLICATION_KEY")
schema = os.getenv("SCHEMA_FILEPATH")

class EndPoint(AdventureWorksApiStream): # nome da stream = endpoint a ser extraido
    """Define custom stream."""

    def print_endpoint(self):
        self.logger.info(f"\n### EXTRAINDO ENDPOINT {name.upper()} ###\n")
    
    name = name  # nome do endpoint
    path = path # pasta do endpoint
    primary_keys: t.ClassVar[list[str]] = primary_keys
    replication_key = replication_key
    # Optionally, you may also use `schema_filepath` in place of `schema`:
    schema_filepath = SCHEMAS_DIR / schema  # noqa: ERA001              # referenciar ao schema criado
