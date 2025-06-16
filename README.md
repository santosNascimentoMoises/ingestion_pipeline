# PIPELINE



## SPARK - Extração de Dados com PySpark via JDBC SQL Server

### Config.py
- Lista de schemas a serem extraídos, onde os comentados são preterídos

```python
schema_list_extract = [
    'HumanResources',
    # 'Person',
    # 'Production',
    # 'Purchasing',
    # 'Sales'...
]
```
- Autenticação via variáveis de ambiente. (ver .env-exemple de exemplo)
- Extração seletiva de schemas, configurada via arquivo `config.py`.
---
### spark_script.py
- Leitura dinâmica dos **schemas** e respectivas **tabelas** de um banco SQL Server.
- Salvamento dos dados no formato **Parquet**.
- Execução escalável com **Apache Spark** local.
- Conexão: JDBC via driver **mssql-jdbc-12.10.0.jre8.jar**.
- Processamento distribuído: Spark rodando em modo local (**local[2]**).
- Exporta cada tabela como um arquivo Parquet no diretório configurado ( **output/db** ).

### Docker - spark.Dockerfile
- Características:
- Base: eclipse-temurin:17-jdk-jammy.
- Instalação do Python 3.11 e dependências de sistema.
- Instalação do PySpark 3.5.0.
- Inclusão do driver JDBC SQL Server.
- Executa automaticamente o script spark_script.py.

### Execução Local (Sem Docker)
- Pré-requisitos:
- Python >= 3.11
- Java (JDK) >= 8
- Spark >= 3.5
- Driver JDBC (mssql-jdbc-12.10.0.jre8.jar) na raiz do projeto

## Variáveis de Ambiente: .env

```bash
export MSQL_DB_NAME=seu_banco
export MSQL_DB_USER=seu_usuario
export MSQL_DB_PASSWORD=sua_senha
export MSQL_DB_HOST=ip_ou_host_do_sqlserver
```

---
## AZURE - Igestão de dados no container
Este realizar a **ingestão de dados em arquivos Parquet** no serviço **Azure Blob Storage**, utilizando a biblioteca oficial `azure-storage-blob`.

### Funcionalidades

- **Renomeação automatizada** dos arquivos Parquet para um padrão consistente (`schema-tabela.parquet`).
- Upload dos arquivos para o **Azure Blob Storage**, utilizando autenticação via **connection string** segura.
- Organização dos blobs dentro do container Azure no diretório lógico `/teste/`.

### Conexão com o Azure Blob Storage:
A configuração de conexão é feita através de variáveis de ambiente e da string em **config.py**.

```python
storage_account_name = os.getenv('AZURE_STORAGE_ACCOUNT_NAME')
sas_token = os.getenv('AZURE_STORAGE_ACCOUNT_KEY')

connection_string = (
    "DefaultEndpointsProtocol=https;"
    f"AccountName={storage_account_name};"
    f"AccountKey={sas_token};"
    "EndpointSuffix=core.windows.net"
)
container_name_string = os.getenv('AZURE_CONTAINER_NAME')
```
### Docker — azure-ingestion.Dockerfile
- Pré-requisitos:
- Python >= 3.11
- Biblioteca: azure-storage-blob

### Variáveis de Ambiente
```bash
export AZURE_STORAGE_ACCOUNT_NAME=seu_storage
export AZURE_STORAGE_ACCOUNT_KEY=sua_chave
export AZURE_CONTAINER_NAME=seu_container
```
---
## JOB Databricks Notebook
Realiza a **ingestão de dados armazenados no Azure Blob Storage**, a leitura dos arquivos no Databricks (parquet), transformação para Delta Lake e criação de tabelas gerenciadas no metastore do Databricks.
Adicionalmente, contempla um script externo que permite **acionar programaticamente jobs no Databricks via API REST**, permitindo orquestrações CI/CD, automações ou execuções sob demanda.

### Funcionalidades

- Conexão com o **Azure Blob Storage** via `connection_string`.
- Listagem dinâmica dos arquivos em uma pasta lógica no container Azure.
- Leitura dos arquivos Parquet diretamente do blob.
- Escrita dos dados no formato Delta Lake e criação de tabelas no catálogo.
- Acionamento externo de jobs configurados no Databricks via **API REST v2.1**.
---

### Notebook Databricks

#### Dependências

- `pandas`
- `azure-storage-blob`
- `azure-storage-filedatalake`
- `pyspark` (nativo do Databricks)

#### Conexão com Azure Blob Storage

```python
from azure.storage.blob import ContainerClient, BlobClient
from io import BytesIO
import pandas as pd
```

```python
connection_string = (
    "DefaultEndpointsProtocol=https;"
    "AccountName=<account_name>;"
    "AccountKey=<account_key>;"
    "EndpointSuffix=core.windows.net"
)

container_name = "<container_name>"

```
### Lógica de Leitura e Escrita

- Para cada blob:
- Faz o download em memória (BytesIO).
- Converte para DataFrame Pandas → Spark DataFrame.
- Realiza saneamento dos nomes das colunas (substituição de espaços, traços e pontos por underscore).
- Persiste como tabela Delta no catálogo .
