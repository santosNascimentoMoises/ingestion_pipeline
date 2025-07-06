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
meltano_file = Path("meltano-cobaia.yml")

# with meltano_file.open("r") as f:
#     data = yaml.load(f)

# # Acesso ao campo do extractor da tap
# extractor = [e for e in data["plugins"]["extractors"] if e["name"] == "tap_adventureworksapi"][0]

# # modifica o campo "select"
# extractor["select"] = ["novocampo23.*"]

# # Salva o arquivo atualizado
# with meltano_file.open("w") as f:
#     yaml.dump(data, f)

def yml_stream_change(meltano_file):
    
    with meltano_file.open("r") as f:
      data = yaml.load(f)

    # Acesso ao campo do extractor da tap
    extractor = [e for e in data["plugins"]["extractors"] if e["name"] == "tap_adventureworksapi"][0]

    # modifica o campo "select"
    extractor["select"] = ["novocampo234.*"]

    # Salva o arquivo atualizado
    with meltano_file.open("w") as f:
        yaml.dump(data, f)
    
if __name__ == "__main__":
    yml_stream_change(meltano_file)
