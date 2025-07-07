"""AdventureWorksApi tap class."""

from __future__ import annotations

from singer_sdk import Tap
from singer_sdk import typing as th  # JSON schema typing helpers

# TODO: Import your custom stream types here:
from tap_adventureworksapi import streams


class TapAdventureWorksApi(Tap):
    """AdventureWorksApi tap class."""

    name = "tap_adventureworksapi"

    # TODO: Update this section with the actual config values you expect:
    config_jsonschema = th.PropertiesList(
        th.Property("api_url", th.StringType, description="URL base da API"),
        th.Property("user", th.StringType, description="admin"),
        th.Property("password", th.StringType, description="Senha para autenticação"),
    ).to_dict()

    def discover_streams(self) -> list[streams.AdventureWorksApiStream]:
        """Return a list of discovered streams.

        Returns:
            A list of discovered streams.
        """
        return [
            streams.EndPoint(self),
        ]


if __name__ == "__main__":
    TapAdventureWorksApi.cli()
