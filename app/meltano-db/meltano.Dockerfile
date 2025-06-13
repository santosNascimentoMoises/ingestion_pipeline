FROM meltano/meltano:latest

WORKDIR /app

RUN meltano init . --no-interaction && \
    meltano add extractor tap-postgres && \
    meltano add loader target-csv && \
    meltano install

COPY meltano.yml .

VOLUME /app/meltano_output/db

CMD ["meltano", "run", "tap-postgres", "target-csv"]