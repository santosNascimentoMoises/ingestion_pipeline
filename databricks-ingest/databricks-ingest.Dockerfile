# Base leve com Python
FROM python:3.10-slim


# Diretório de trabalho
WORKDIR /app

COPY . .

# Instala a CLI e cria config da Databricks
RUN pip install --no-cache-dir databricks-sdk==0.57.0

CMD ["python", "ingest_raw.py"]
