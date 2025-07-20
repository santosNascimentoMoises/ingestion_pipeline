import os
import subprocess

models_path = "models/marts"
output_path = "docs/stg"

# Garante que o diretório de saída exista
os.makedirs(output_path, exist_ok=True)

sql_models = [i.replace('.sql','') for i in os.listdir(models_path)]
# sql_models = ['stg_customer']
# Identifica todos os modelos SQL do diretório

# Gera documentação YAML por modelo
for model in sql_models:
    print(f"Gerando documentação YAML para: {model}")
    result = subprocess.run(
        [
            "dbt",
            "run-operation",
            "generate_model_yaml",
            "--args",
            f'{{"model_names": ["{model}"], "upstream_descriptions": true}}'
        ],
        capture_output=True,
        text=True
    )
    with open(f"{output_path}/{model}.yml", "w") as f:
        f.write(result.stdout)
