"""REST client handling, including AdventureWorksApiStream base class."""
from config import API_URL, API_USER, API_PASSWORD
from __future__ import annotations
import time
import decimal
import typing as t
from importlib import resources

from requests.auth import HTTPBasicAuth
from singer_sdk.helpers.jsonpath import extract_jsonpath
from singer_sdk.pagination import BaseOffsetPaginator
from singer_sdk.streams import RESTStream

if t.TYPE_CHECKING:
    import requests
    from singer_sdk.helpers.types import Context


# TODO: Delete this is if not using json files for schema definition
SCHEMAS_DIR = resources.files(__package__) / "schemas"


class AdventureWorksApiStream(RESTStream):
    """AdventureWorksApi stream class."""

    # Update this value if necessary or override `parse_response`.
    records_jsonpath = "$[*]"

    # Update this value if necessary or override `get_new_paginator`.
    next_page_token_jsonpath = None  # noqa: S105

    @property
    def url_base(self) -> str:
        """Return the API URL root, configurable via tap settings."""
        # TODO: hardcode a value here, or retrieve it from self.config
        return API_URL

    @property
    def authenticator(self) -> HTTPBasicAuth:
        """Return a new authenticator object.

        Returns:
            An authenticator instance.
        """
        return HTTPBasicAuth(
            username=self.config.get("username", API_USER),
            password=self.config.get("password", API_PASSWORD),
        )

    # @property
    # def http_headers(self) -> dict:
    #     """Return the http headers needed.

    #     Returns:
    #         A dictionary of HTTP headers.
    #     """
    #     # If not using an authenticator, you may also provide inline auth headers:
    #     # headers["Private-Token"] = self.config.get("auth_token")  # noqa: ERA001
    #     return {}

    def get_new_paginator(self) -> BaseOffsetPaginator | None:
        """Create a new pagination helper instance.

        If the source API can make use of the `next_page_token_jsonpath`
        attribute, or it contains a `X-Next-Page` header in the response
        then you can remove this method.

        If you need custom pagination that uses page numbers, "next" links, or
        other approaches, please read the guide: https://sdk.meltano.com/en/v0.25.0/guides/pagination-classes.html.

        Returns:
            A pagination helper instance, or ``None`` to indicate pagination
            is not supported.
        """
        return BaseOffsetPaginator(
            start_value=0,      # offset inicial
            page_size=300,      # limite por página (defina conforme a API)            
        )
    
    @property
    def request_timeout(self) -> int:
        return 30  # segundos
    
    @property
    def max_retries(self) -> int:
        return 5  # número máximo de tentativas

    @property
    def retry_backoff(self) -> float:
        return 2.0  # multiplicador de tempo entre tentativas (backoff exponencial)

    @property
    def max_requests_per_minute(self) -> int:
        return 300  # 1 req/s
    
    def get_url_params(
        self,
        context: Context | None,  # noqa: ARG002
        next_page_token: t.Any | None,  # noqa: ANN401
    ) -> dict[str, t.Any]:
        """Return a dictionary of values to be used in URL parameterization.

        Args:
            context: The stream context.
            next_page_token: The next page index or value.

        Returns:
            A dictionary of URL query parameters.
        """
        params: dict = {
            "limit": 300,
            "offset": next_page_token or 0,
            "sort": "asc"
        }
        if self.replication_key:
            params["sort"] = "asc"                        # VERIFICAR
            params["order_by"] = self.replication_key
        return params

    def parse_response(self, response: requests.Response) -> t.Iterable[dict]:
        """Parse the response and return an iterator of result records.

        Args:
            response: The HTTP ``requests.Response`` object.

        Yields:
            Each record from the source.
        """
        # TODO: Parse response body and return a set of records.
        json_response = response.json()
        time.sleep(0.1)  # pausa após cada página
        yield from json_response.get("data", [])
