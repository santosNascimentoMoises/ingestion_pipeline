"""REST client handling, including AdventureWorksApiStream base class."""
from __future__ import annotations
import os
import time
import requests
import typing as t
from importlib import resources

from requests.auth import HTTPBasicAuth
from singer_sdk.pagination import BaseOffsetPaginator
from singer_sdk.streams import RESTStream

# customização para a API SalesOrderDetail
from singer_sdk.exceptions import FatalAPIError

if t.TYPE_CHECKING:
    import requests
    from singer_sdk.helpers.types import Context


SCHEMAS_DIR = resources.files(__package__) / "schemas"

API_URL=os.getenv("API_URL")
API_USER=os.getenv("API_USER")
API_PASSWORD=os.getenv("API_PASSWORD")

class AdventureWorksApiStream(RESTStream):
    """AdventureWorksApi stream class."""
    PAGE_SIZE = 80000
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

    def get_new_paginator(self) -> BaseOffsetPaginator | None:
        return BaseOffsetPaginator(
            start_value=0,      # offset inicial
            page_size=self.PAGE_SIZE,      # limite por página (defina conforme a API)            
        )
    
    @property
    def request_timeout(self) -> int:
        return 60  # segundos
    
    def should_retry(self, response: requests.Response) -> bool:
        return response.status_code in [429, 500, 502, 503, 504]

    @property
    def max_retries(self) -> int:
        return 10  # número máximo de tentativas

    @property
    def retry_backoff(self) -> float:
        return 2.0  # multiplicador de tempo entre tentativas (backoff exponencial)

    @property
    def max_requests_per_minute(self) -> int:
        return 60  # 1 req/s
    
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
            "limit": self.PAGE_SIZE,
            "offset": next_page_token or 0,
            "sort": "asc"
        }
        if self.replication_key:
            # params["sort"] = "asc"                        # VERIFICAR
            params["order_by"] = self.replication_key
        return params


    def request_records(self, context):
        next_page_token = 0

        while True:
            attempt = 0
            while attempt < self.max_retries:
                try:
                    self.logger.info(f"### ATTEMPT {attempt + 1}/{self.max_retries} | Offset={next_page_token}")

                    url = self.get_url(context)
                    params = self.get_url_params(context, next_page_token=next_page_token)
                    headers = self.http_headers
                    auth = self.authenticator
                    timeout = self.request_timeout

                    response = requests.get(
                        url,
                        params=params,
                        headers=headers,
                        auth=auth,
                        timeout=timeout,
                    )
                    response.raise_for_status()

                    self.logger.info("### REQUEST SUCCESSFUL.")
                    records = list(self.parse_response(response))

                    # yield os dados extraídos
                    yield from records

                    if not records or len(records) < self.PAGE_SIZE:
                        self.logger.info("### END OF PAGINATION: FEWER RECORDS THAN PAGE_SIZE OR EMPTY")
                        return

                    next_page_token += self.PAGE_SIZE
                    time.sleep(0.1)  # intervalo entre páginas
                    break  # sair do retry loop

                except requests.exceptions.Timeout:
                    self.logger.warning("### TIMEOUT DETECTED! RETRYING AFTER BACKOFF...")
                    time.sleep(self.retry_backoff * (2 ** attempt))
                    attempt += 1

                except requests.exceptions.RequestException as ex:
                    self.logger.error(f"### NON-RECOVERABLE REQUEST ERROR: {ex}")
                    raise ex

            else:
                raise FatalAPIError("### API FAILED AFTER MAXIMUM NUMBER OF ATTEMPTS")
    
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
