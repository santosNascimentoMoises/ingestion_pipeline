# 1. Instala dependências do sistema (formato corrigido)
RUN apt-get install -y --no-install-recommends \
    git \
    gcc \
    python3-dev \
    unixodbc-dev \
    freetds-dev \
    curl && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql18 && \
    rm -rf /var/lib/apt/lists/*

RUN RUN pip install --upgrade pip setuptools wheel && \
    pip install meltano pyodbc sqlalchemy-pyodbc-mssql cryptography && \

FROM python:3.10-slim
RUN rm -rf .meltano/plugins/.lock .meltano/.venv
RUN pip install --upgrade pip setuptools wheel

COPY meltano.yml .

# RUN pip install git+https://github.com/BuzzCutNorman/tap-mssql.git

# Instala plugins do Meltano
RUN meltano install

COPY requirements.txt .

RUN pip install -r requirements.txt || true

RUN meltano install

VOLUME /app/meltano_output/db

CMD ["meltano", "--environment=dev", "run", "tap-mssql", "target-parquet"]

# meltano --environment=dev run tap-mssql target-parquet
# meltano --environment=dev run tap-rest-api-msdk target-parquet