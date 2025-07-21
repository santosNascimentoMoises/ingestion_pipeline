"""AdventureWorksApi entry point."""

from __future__ import annotations

from tap_adventureworksapi.tap import TapAdventureWorksApi

TapAdventureWorksApi.cli()
