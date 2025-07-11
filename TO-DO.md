# TO-DO CHECKPOINT-3 :writing_hand:
- [X] :+1: consegui extrair todas as APIs :muscle::muscle:
- [X] :+1: consegui fazer o airflow rodar um simples comando
- [X] :+1: consegui fazer o airflow rodar o meltano pra extrair de API
- [X] :+1: configurar o dockeroperator pra rodar o databricks ingest
- [X] :+1: paralelizar a extração do banco de dados (por schema inicialmente)
- [ ] após isso, configurar dockeroperator pra rodar os demais dockers (spark-db)
- [ ] configurar env e diretórios corretamente (spark-db)
- [ ] criar config de {schema.tabela} (spark-db)
lembrar do docker-compose também
- [X] :+1: extração de {schema.tabela} via spark configurado
- [X] :+1: testar a ingestão do databricks
- [X] :+1: criado notebook para transformar de raw pra delta
- [ ] instalar dbt core e configurar projeto
- [ ] modelar uma stg e uma dim bem simples pra testar o dbt e tadabricks
- [ ] modelar o restante
    - descrever... fct, dim, etc...
- [ ] lembrar da dim_dates
- [ ] estudo dos indicadores e possíveis visualizações dos dados
- [ ] https://docs.getdbt.com/docs/core/docker-install
- [ ] x
- [ ] x
- [ ] x
- [ ] x
- [ ] x
- [ ] x
- [ ] x
- [ ] x

OBS antes de dormir eu deixei em aberto:
- configurar o schema table da extração com spark
- configurar função de retorno dos streams. ja tem uma mas precisa acertar a parte do return. eu quero só [schema,table] - falta testar
- declarar "volume_path" no schema table



# AL DAY COMANDS
source .venv/bin/activate
source .env
echo $TESTE

# se der
- [ ] quem sabe plotar alguns gráficos no notebook databricks
- [ ] estudar sobre o funcionamento do parquet no databricks
- [ ] cron?
- [ ] como disparar as dags "usando tempo"?
- [ ] lembrar de citar que em contextos de produção o sistema ficaria em VM na nuvem (exemplos)

GCP (Google Cloud)	e2-medium (2 vCPU, 4GB RAM)
AWS EC2	t3.micro, t3.small
Azure	B1s
Oracle Cloud	VM.Standard.A1.Flex

- [ ] 
- [ ] 
- [ ] 
- [ ] 

## comandos de teste databricks_cli via docker compose
docker volume create shared-api # volume para dados da API

docker compose up --build databricks-ingest

docker compose build --no-cache databricks-ingest

docker compose up databricks-ingest


# comandos de teste spark-db
docker compose build --no-cache spark-db
docker compose up --build spark-db
docker compose run spark-db

docker compose up spark-db

docker compose down spark-db

docker compose run --rm spark-db


captura string no job databrics
dbutils.widgets.text("input_string", "")
input_string = dbutils.widgets.get("input_string")
print(f"String recebida: {input_string}")