# TO-DO CHECKPOINT-3 :writing_hand:
- [X] :+1: consegui extrair todas as APIs :muscle::muscle:
- [X] :+1: consegui fazer o airflow rodar um simples comando
- [X] :+1: consegui fazer o airflow rodar o meltano pra extrair de API
- [ ] configurar o dockeroperator pra rodar o databricks ingest
- [ ] paralelizar a extração do banco de dados (por schema inicialmente)
- [ ] após isso, configurar dockeroperator pra rodar os demais dockers (spark-db)
- [X] :+1: testar a ingestão do databricks
- [ ] instalar dbt core e configurar projeto
- [ ] modelar a stg e uma dim bem simples
- [ ] modelar o restante
    - descrever... fct, dim, etc...

# AL DAY COMANDS
- source .venv/bin/activate
- source .env


# se der
- [ ] quem sabe plotar alguns gráficos no notebook databricks


## comandos de teste databricks_cli via docker compose
docker volume create shared-api # volume para dados da API

docker compose up --build databricks-ingest

docker compose build --no-cache databricks-ingest

docker compose up databricks-ingest


