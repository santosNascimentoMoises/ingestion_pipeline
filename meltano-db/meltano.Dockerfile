FROM python:3.10-slim

# 1. Instala dependências essenciais
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc \
    python3-dev \
    openjdk-17-jdk-headless && \
    rm -rf /var/lib/apt/lists/* && \
    java -version

# 2. Instala o Meltano globalmente
RUN pip install --no-cache-dir meltano

# 3. Configura o projeto
WORKDIR /app

# Solução alternativa para
RUN mkdir -p .meltano && meltano init .

# 4. Adiciona plugins específicos
RUN meltano add extractor tap-postgres && \
    meltano add loader target-csv

# 5. Copia configurações e instala
COPY meltano.yml .
RUN meltano install

# 6. Volume e comando
VOLUME /app/meltano_output/db
CMD ["meltano", "run", "tap-postgres", "target-csv"]