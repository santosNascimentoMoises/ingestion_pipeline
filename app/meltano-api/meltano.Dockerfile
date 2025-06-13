FROM meltano/meltano:latest

WORKDIR /app

#plugins
RUN meltano init . --no-interaction && \
    meltano add extractor tap-rest-api && \
    meltano add loader target-csv && \
    meltano install

COPY meltano.yml .

#volume de output
VOLUME /app/meltano_output/api

CMD ["meltano", "run", "tap-rest-api", "target-csv"]