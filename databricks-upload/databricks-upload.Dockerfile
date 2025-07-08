FROM python:3.9-slim

# Diretório de trabalho
WORKDIR /app

COPY job_databricks.py .

# Instala dependências (apenas requests, já que json é built-in)
RUN pip install --no-cache-dir requests

# Define o comando padrão (pode ser sobrescrito com docker run)
CMD ["python", "job_databricks.py"]
