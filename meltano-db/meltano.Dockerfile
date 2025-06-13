
FROM meltano/meltano:latest

WORKDIR /app

# Instala Java
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk && \
    rm -rf /var/lib/apt/lists/* && \
    java -version  # Verifica a instalação

RUN mkdir -p .meltano && \
    echo -e "n\n" | meltano init .  # Responde automaticamente às prompts

RUN pip install -r requirements.txt || true

# plugins
RUN meltano add extractor tap-postgres && \
    meltano add loader target-csv && \
    meltano install

# dopia configurações
COPY meltano.yml .

# diretório para saída dos dados
VOLUME /app/meltano_output/db

CMD ["meltano", "run", "tap-postgres", "target-csv"]