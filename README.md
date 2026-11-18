hoje dia 18/11/2026 eu vim "visitar" esse código, não sei porque kkk
vi que alguém "clonou" esse repositório kkk (loucura).
bom, eu fui um dos caras mais fodas do LH, mesmo assim, a contratação não veio.
se tu entender "metade" da lógica que eu tentei implementar nesse projeto, tu também é um cara foda kkk
muito provavelmente deve haver erros, então, não copie tudo as cegas.
que tudo dê certo pra ti, boa sorte...


... ou não!!! kkkkkk

hoje, a IA consegue "programar", então a saída pra se dar bem no LH seria fazer algo "fora do padrão esperado".
ex.: caso seja o mesmo "projeto/case" - coisas que eu fiz que a IA provavelmente não daria uma "resposta":

- configurar um mesmo docker que consegue fazer extração de vários endpoints concomitantes, um do outro;
- configurar um databricks work para enviar um "ok" ao seu Airflow (local) para iniciar a rodagem do dbt (sem necessidade de "chutar" quanto tempo vai demorar pra finalizar o a ingestão no databricks, pra só depois rodar o dbt);
- melhorar o tap de extração da API (o segredo é ser BRUTO!!! KKK puxar o máximo de linhas possível de uma vez só, e configurar um "retry" consistente);
acho que já rodei todo esse pipeline em 8 min (mas a média é 12 min por conta da API).

fora esse lance de "pensar fora da caixa", tem que saber se COMUNICAR bem (a IA pode até saber programar, mas quem vai apresentar o trampo é VC!), estudar inglês e interagir com o máximo de pessoas possíveis (sem ser "chato").

enfim, foram bons tempos #saudade.
foi uma das coisas mais FODAS! que eu fiz na vida.
pra superar isso aqui só fazendo um filho ou passando em um concurso que pague uns 30k kkk


# PIPELINE

Pipeline modular para extração, ingestão e processamento de dados utilizando PySpark, Azure Blob Storage e Databricks.

# Configuração do Ambiente

## Clonando o projeto

Primeiramente, é necessário clonar o repo localmente via SSH utilizando o comando `git clone` no link. 
* `git clone git@github.com:santosNascimentoMoises/ingestion_pipeline.git`

Esse projeto trabalha inteiramente com docker, portando é necessário a instalação no pc local.

Em casos de testes ou features, vai ser necessário configurar ambientes virtuais python.

## Criando um ambiente virtual

É preciso criar um na pasta home do projeto (caso você ainda não o tenha feito).

* `python -m venv venv` ou

Ativar o ambiente virtual

* `source venv/bin/activate` no Linux ou
* `source venv/Scripts/activate` em bash no Windows, ou ainda

## Instalando as bibliotecas

Necessário instalar as bibliotecas listadas no arquivo **requirements.txt**. 

* `pip install -r requirements.txt` ou

# Ferramentas e Scripts

## CONFIG 

Pasta onde se configura (via script python) quais endpoints ou schema.table serão extraidos. Basta configurar para 'False' e o endpoint/tabelas serão preteridos.

## SPARK - Extração de Dados com PySpark via JDBC SQL Server

- Leitura dinâmica dos **schemas** e respectivas **tabelas** de um banco SQL Server.
- Salvamento dos dados no formato **Parquet**.
- Execução escalável com **Apache Spark** local.
- Conexão: JDBC via driver **mssql-jdbc-12.10.0.jre8.jar**.
- Processamento distribuído: Spark rodando em modo local (**local[2]**).
- Exporta cada tabela como um arquivo jsonl no volume configurado no docker compose:
```bash
shared-api:
    driver: local
shared-db:
      driver: local
```
## Meltano SDK

**Tap Singer personalizado** utilizando o Meltano SDK, projetado para realizar **extração de dados de APIs RESTful** de forma modular e escalável.

---

## Dependências

- **Meltano SDK for Singer Taps**
- **Python 3.8+**
- Estrutura modular baseada em:
  - `tap.py` — ponto de entrada e configuração global do tap
  - `streams/` — definição de endpoints e regras de paginação
  - `schemas/` — validação dos dados extraídos via JSON Schema

---

## Databricks injest
Realiza a **ingestão de dados armazenados localmente**, para o ambiente RAW no databricks.

### Funcionalidades

utiliza o WorkspaceClient para realizar a escritas dos dados brutos no ambiente em nuvem.

---

### Notebooks Databricks

**transform_jsonl_to_delta**
Realiza a transformação dos dados brutos extraidos para tabelas Delta.

**start_cluster**
Um notebook simples (print) para iniciar o cluster, ganhando tempo equanto a exttração de fato ocorre. Ao fim da extração, o cluster estará disponível para gerar as tabelas Delta.

### Airflow - via docker compose

Versão: apache/airflow:2.10.4-python3.11

Realiza a orquestração das tasks do pipeline.

# CI/CD
Uma das formas de ativar o pipeline na ordem de execução correta é atravez do **MAKEFILE**

comando:

*make build_pipeline*

### função
Realiza a criação das imagens dockers.
Adcionalmente dispara a DAG do pipeline.

# Limpeza do ambiente
O mesmo makefile contem o comando:

*make clear*

Realiza a limpeza de todos os dados relacionados ao docker compose do pc HOST (local)
