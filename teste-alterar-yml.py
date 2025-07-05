""" pip install ruamel.yaml

exemplo de yml:

plugins:
  extractors:
    - name: tap_adventureworksapi
      config:
        api_key: OLD_KEY

"""
from ruamel.yaml import YAML
from pathlib import Path

yaml = YAML()
yaml.preserve_quotes = True

# Caminho do meltano.yml
meltano_file = Path("meltano.yml")

# Lê o arquivo
with meltano_file.open("r") as f:
    data = yaml.load(f)

# Modifica o campo desejado
extractors = data.get('plugins', {}).get('extractors', [])
for extractor in extractors:
    if extractor.get("name") == "tap_adventureworksapi":
        extractor.setdefault("config", {})["api_key"] = "NEW_KEY"

# Salva o arquivo
with meltano_file.open("w") as f:
    yaml.dump(data, f)