# TO-DO CHECKPOINT-3 :writing_hand:
- [X] :+1: consegui extrair todas as APIs :muscle::muscle:
- [X] :+1: consegui fazer o airflow rodar um simples comando
- [X] :+1: consegui fazer o airflow rodar o meltano pra extrair de API
- [X] :+1: configurar o dockeroperator pra rodar o databricks ingest
- [X] :+1: paralelizar a extração do banco de dados (por schema inicialmente)
- [X] :+1: após isso, configurar dockeroperator pra rodar os demais dockers
- [X] :+1: configurar env e diretórios corretamente (spark-db)
- [X] :+1: criar config de {schema.tabela} (spark-db)
lembrar do docker-compose também
- [X] :+1: extração de {schema.tabela} via spark configurado
- [X] :+1: testar a ingestão do databricks
- [X] :+1: criado notebook para transformar de raw pra delta
- [X] :+1: criado job databricks para geração da bronze
- [X] :+1: instalar dbt core e configurar projeto
- [X] :+1: modelar uma stg e uma dim bem simples pra testar o dbt e tadabricks
- [X] :+1: modelar o restante
- [X] :+1: dim_products
- [X] :+1: dim_address
- [X] :+1: dim_customer
- [X] :+1: dim_sales_person (vendedor)
- [X] :+1: dim_store
- [X] :+1: fct_sales # TRATAR AS CHAVES DE DATAS: final do arquivo
- [X] :+1: fct_aggregadas
- [X] :+1: snp_customer
- [X] :+1: fct_production
- [X] :+1: fct_inventory (incremental!)
- [X] :+1: dim_dates
- [X] :+1: ymls
- [X] :+1: testes
- [X] :+1: analisar os uniq/distinct das dim e revisar as chaves_sk
se distinct(id) == n rows, vale a pena deixar só o id como chave na dim
- [X] :+1: diagrama de relacionamento das tabelas
- [X] :+1: orquestrar dbt - comand? bash?

boas práticas trabalhando com VMs - email de alerta caso o tempo seja excedido
retry em caso de falha

# AL DAY COMANDS
source .venv/bin/activate
source .env
echo $TESTE
cd dbt_aw
dbt deps
dbt debug

source ../.env
echo $TESTE

# se der
- [ ] quem sabe plotar alguns gráficos no notebook databricks ("consolidação da modelagem")
- [ ] apresentar do maior "grao" pro menor "grao"
bignumber > série temporal, divisão por "lojas", produto mais vendido, etc...
- [ ] cron?
- [ ] como disparar as dags "usando tempo"?
- [ ] lembrar de citar que em contextos de produção o sistema ficaria em VM na nuvem (exemplos)

GCP (Google Cloud)	e2-medium (2 vCPU, 4GB RAM)
AWS EC2	t3.micro, t3.small
Azure	B1s
Oracle Cloud	VM.Standard.A1.Flex

# tipos de cast:

::int
::string
::float
::number
::timestamp

# OBS>

dbt docs generate
dbt docs serve
lsof -i :8080


dbt run-operation generate_model_yaml --args '{"model_names": ["stg_work_order"], "upstream_descriptions": true}' > dim_address.yml
