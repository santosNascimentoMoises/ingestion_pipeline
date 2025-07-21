FROM python:3.10-slim

# apenas git, se necessário
RUN apt-get update && apt-get install -y --no-install-recommends git \
 && rm -rf /var/lib/apt/lists/*

RUN pip install dbt-databricks

WORKDIR /dbt

COPY . .

# ENTRYPOINT ["dbt"]
