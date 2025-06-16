FROM meltano/meltano:latest

WORKDIR /app

# Instala Java (OpenJDK 17)
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk && \
    rm -rf /var/lib/apt/lists/*
    
#plugins
RUN meltano init . --no-interaction && \
    meltano add extractor tap-rest-api && \
    meltano add loader target-csv && \
    meltano install

COPY meltano.yml .

#volume de output
VOLUME /app/meltano_output/api

CMD ["meltano", "run", "tap-rest-api", "target-csv"]






# RUN meltano install extractor tap-rest-api-msdk || \
#     (cd /path/to/tap-rest-api-msdk && pip install -e .)