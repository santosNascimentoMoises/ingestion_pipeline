# Base leve com Python
FROM python:3.10-slim


# Diretório de trabalho
WORKDIR /app

# Instala a CLI e cria config da Databricks
RUN pip install --no-cache-dir databricks-cli \
    && mkdir -p /root/.databricks \
    && echo -e "[DEFAULT]\nhost=$DATABRICKS_HOST\ntoken=$DATABRICKS_TOKEN" > /root/.databricks/config
