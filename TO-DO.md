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
- [ ] modelar o restante
    - descrever... fct, dim, etc...
- [X] :+1: dim_products
- [X] :+1: dim_address
- [X] :+1: dim_customer
- [X] :+1: dim_sales_person (vendedor)
- [X] :+1: dim_store
- [X] :+1: fct_sales # TRATAR AS CHAVES DE DATAS: final do arquivo
- [ ] dim_ship_method
Order current status. 1 = In process; 2 = Approved; 3 = Backordered; 4 = Rejected; 5 = Shipped; 6 = Cancelled
i id da venda vai recebendo novas linhas conforme o status muda.
a mesma venda teria a row de "data da venda" e outra row de "data de envio".
- [ ] dim_offer
- [X] :+1: fct_production
- [ ] fct_stok (incremental?) - snapshot!
- [X] :+1: dim_dates
- [ ] analisar os uniq/distinct das dim e revisar as chaves_sk
se distinct(id) == n rows, vale a pena deixar só o id como chave na dim
- [ ] diagrama de relacionamento das tabelas
- [ ] estudo dos indicadores e possíveis visualizações dos dados
- [ ] testes
- [ ] orquestrar dbt - comand? bash?

# AL DAY COMANDS
source .venv/bin/activate
source .env
echo $TESTE

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

11h da manhã na dag empty sensor

a extração pode ser "antes", as 10h por exemplo. considerar o tempo que ela leva, a dag ext 10:50, transofrm as 11.

vai depender do execution delta.
1h pra trás, a extra deu certo a transformacao vai continuar.
