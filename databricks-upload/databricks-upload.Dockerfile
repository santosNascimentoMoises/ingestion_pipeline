FROM python:3.9-slim

WORKDIR /app
COPY . .

RUN pip install --no-cache-dir \
    databricks-cli \
    databricks-sql-connector \
    pyspark \
    python-dotenv

CMD ["python", "run_local.py"]