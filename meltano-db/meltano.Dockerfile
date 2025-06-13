FROM python:3.10-slim

# Instala dependências do sistema
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc \
    python3-dev \
    openjdk-17-jdk-headless && \
    rm -rf /var/lib/apt/lists/* && \
    java -version

# Cria e ativa um virtualenv
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Instala o Meltano
RUN pip install --no-cache-dir meltano

# Configura o projeto
WORKDIR /app
RUN meltano init . --no_install && \
    meltano add extractor tap-postgres && \
    meltano add loader target-csv

# Copia configurações
COPY meltano.yml .

# Instala plugins
RUN meltano install

# Volume para saída
VOLUME /app/meltano_output/db

# Usa o caminho absoluto do meltano no virtualenv
CMD ["/opt/venv/bin/meltano", "run", "tap-postgres", "target-csv"]