# lembrar que fazer ctrl + shift + V, abre o preview

# ler variável de ambiente
source .env

## testar
echo $MENSAGEM_TESTE_ENV

# criar ambiente python separado - VENV
## venv python
python -m venv venv

## ativar
source venv/bin/activate 

### desativar se necessário
deactivate

# COMANDOS DO MAKE FILE - UTIL EM TESTES RODANDO LOCALMENTE
## limpar memória
make memoria

## limpar tudo de docker
clean-docker

# Comandos docker
## montar docker compose
docker compose up --build

## se quiser dar down e subir novamente
docker compose down && docker compose up --build

## se quiser ver os compose
docker compose ps

## se quiser dar down
docker compose down

<!-- from azure.storage.blob import BlobServiceClient
from azure.identity import DefaultAzureCredential
from pyspark.sql import SparkSession
pandas -->

(base) moises-ubuntu@moises-ubuntu-Aspire-A515-45:~/ingestion_pipeline_checkpoint2$ w
w Enable Watch


CMD ["sh", "-c", "clear && /bin/bash"]  # Limpa a tela e abre o shell
