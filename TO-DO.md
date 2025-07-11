# TO-DO CHECKPOINT-3 :writing_hand:
- [X] :+1: consegui extrair todas as APIs :muscle::muscle:
- [X] :+1: consegui fazer o airflow rodar um simples comando
- [X] :+1: consegui fazer o airflow rodar o meltano pra extrair de API
- [X] :+1: configurar o dockeroperator pra rodar o databricks ingest
- [X] :+1: paralelizar a extração do banco de dados (por schema inicialmente)
- [X] :+1: após isso, configurar dockeroperator pra rodar os demais dockers (spark-db)
- [X] :+1: configurar env e diretórios corretamente (spark-db)
- [X] :+1: riar config de {schema.tabela} (spark-db)
lembrar do docker-compose também
- [X] :+1: extração de {schema.tabela} via spark configurado
- [X] :+1: testar a ingestão do databricks
- [X] :+1: criado notebook para transformar de raw pra delta
- [X] :+1: criado job databricks para geração da bronze
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
