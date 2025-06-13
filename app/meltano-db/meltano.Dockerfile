FROM meltano/meltano:latest

WORKDIR /app

# Instala Java (OpenJDK 17)
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk && \
    rm -rf /var/lib/apt/lists/*

#plugins
RUN meltano init . --no-interaction && \
    meltano add extractor tap-postgres && \
    meltano add loader target-csv && \
    meltano install

COPY meltano.yml .

VOLUME /app/meltano_output/db

CMD ["meltano", "run", "tap-postgres", "target-csv"]