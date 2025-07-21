# FROM meltano/meltano:3.7.9

FROM python:3.11-slim

# Defina variáveis de ambiente
ENV MELTANO_VERSION=3.1.0

# Instalações básicas
RUN apt-get update && apt-get install -y git build-essential && \
    pip install "meltano==3.1.0"
    # pip install "meltano==$MELTANO_VERSION"

WORKDIR /app

CMD ["meltano", "--version"]



# #plugins
RUN meltano init .

# # # Instala Java (opcional, se for necessário para algum plugin)
# # RUN apt-get update && \
# #     apt-get install -y openjdk-17-jdk && \
# #     rm -rf /var/lib/apt/lists/*

# # Copia o restante do código do tap customizado (SDK local)
COPY . .

# # # Copia apenas o meltano.yml primeiro para o cache funcionar melhor
# # COPY meltano.yml .

# # COPY tap_adventureworksapi .

# # atualizando
RUN meltano lock --update --all

# # Inicializa projeto (caso seja necessário no CI)
RUN meltano install

# # # Registra o extractor no projeto se não estiver via Hub
# # RUN meltano add extractor tap-adventureworksapi || true

# # # Reinstala para garantir dependências
# # RUN meltano install

# # Output
VOLUME ["/app/api_output/api"]

# CMD ["meltano", "run", "tap_adventureworksapi", "target-jsonl"]
# CMD ["meltano", "run", "tap_adventureworksapi", "target-jsonl", "--select "$API_ENDPOINT""]