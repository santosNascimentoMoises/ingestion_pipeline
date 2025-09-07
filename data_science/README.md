
# Estrutura do Projeto

O script cria e utiliza a seguinte estrutura de diretórios para organizar os arquivos de entrada e saída:

```
.
├── fact_sales.csv         # Arquivo de entrada com os dados brutos de vendas
├── output/                # Diretório de saída para os arquivos CSV processados
├── output_metrics/        # Diretório para métricas e relatórios (criado, mas não utilizado neste script)
├── figures/               # Diretório para gráficos (criado, mas não utilizado neste script)
├── prep_teste_output/     # Diretório para dados de teste (criado, mas não utilizado neste script)
├── x_predict/             # Diretório para previsões futuras (criado, mas não utilizado neste script)
├── clean.py               # Módulo de limpeza da memória durante as análises
└── README.md
```
-----

# Download e Preparação de Dados - loader_data_local.py

Este script Python, `loader_data_local.py`, conecta-se a um banco de dados **Databricks** para extrair dados de vendas e salvá-los localmente em um arquivo CSV. O processo é ideal para preparar um conjunto de dados para análise ou modelagem *offline*.

-----

### ⚙️ Pré-requisitos e Configuração

Para que o script funcione, você deve ter a biblioteca `databricks-sql-connector` instalada e as seguintes variáveis de ambiente configuradas:

1.  **`DATABRICKS_SERVER_HOSTNAME_FULL`**: O nome completo do host do seu *cluster* Databricks.
2.  **`DATABRICKS_HTTP_PATH`**: O caminho HTTP do seu *endpoint* SQL Databricks.
3.  **`DATABRICKS_ACCESS_TOKEN`**: Seu *token* de acesso pessoal do Databricks.

Você pode instalar a biblioteca necessária com o `pip`:

```bash
pip install databricks-sql-connector
```

-----

### 🚀 Como Executar

1.  Garanta que as variáveis de ambiente mencionadas acima estejam definidas no seu ambiente de execução.

2.  Execute o script no terminal:

    ```bash
    python loader_data_local.py
    ```

-----

### 📊 Funcionalidade do Script

1.  **Conexão Segura**: O script estabelece uma conexão segura com o Databricks usando as variáveis de ambiente.
2.  **Execução de Consulta**: Ele executa uma consulta SQL (`SELECT * FROM adventure_works.data_science.fact_sales_day_with_calendar`) para buscar todos os dados de vendas da tabela especificada.
3.  **Conversão para DataFrame**: Os resultados da consulta são convertidos para um **DataFrame do Pandas**, uma estrutura de dados flexível e amplamente utilizada para manipulação de dados em Python.
4.  **Salvamento Local**: Finalmente, o DataFrame é salvo em um arquivo chamado **`fact_sales.csv`** no diretório atual, com o objetivo de preparar os dados para processamento posterior. O parâmetro `index=False` garante que o índice do DataFrame não seja incluído no arquivo CSV.

-----

# Particionando DataFrames - partition_country_product.py
### Como Executar

1.  Certifique-se de que o arquivo de entrada `fact_sales.csv` esteja no mesmo diretório do script.
2.  Execute o script diretamente do terminal:
    ```bash
    python partition_country_product.py
    ```

O script criará automaticamente os diretórios necessários e processará o arquivo de vendas.

-----

### Etapas do Processamento

O script executa as seguintes etapas:

1.  **Criação de Diretórios**: Verifica e cria as pastas `figures`, `output`, `output_metrics`, `prep_teste_output` e `x_predict` para garantir que a estrutura de diretórios esteja pronta para o próximo script de modelagem.
2.  **Carregamento e Agrupamento de Dados**: O arquivo `fact_sales.csv` é lido, e os dados são agrupados por `country_name` (país) e `product_subcategory_name` (subcategoria do produto).
3.  **Geração de Séries Temporais**: Para cada grupo (ex: "Bikes - United States"), o script:
      * **Agrega as vendas** diárias (`product_qty_day`).
      * **Mescla os dados agregados com um template de datas** (`merge_with_date_template`) que vai de 31/05/2011 a 30/06/2014. Isso preenche os dias sem vendas com o valor zero, criando uma série temporal contínua.
4.  **Análise e Sumarização**: Enquanto processa os grupos, o script coleta informações resumidas de cada um (total de itens vendidos, média de vendas, etc.) e as armazena em um DataFrame `df_analyse`.
5.  **Salvamento de Arquivos**: Um novo arquivo CSV é gerado para cada grupo, nomeado de forma padronizada (ex: `bikes-united_states.csv`) e salvo no diretório `output/`.
6.  **Relatório Final**: Um arquivo `analyse_groups.csv` é gerado com as informações resumidas de todos os grupos, fornecendo um panorama geral dos dados.

-----

### Saídas

  * **Arquivos CSV processados**: Múltiplos arquivos CSV, cada um representando a série temporal de vendas de uma subcategoria de produto em um país específico, são salvos no diretório `output/`.
  * **`analyse_groups.csv`**: Um arquivo CSV que contém um resumo das principais métricas de vendas (total de itens, média de vendas não-zero) para cada grupo processado.

-----

# Predição de Vendas com XGBoost - xgboost_model.py

Este projeto utiliza o algoritmo **XGBoost** para prever as vendas diárias de produtos, aplicando uma metodologia de modelagem de séries temporais. O script é desenhado para processar múltiplos arquivos CSV, criar *features* de tempo e de série temporal (como *lags* e médias móveis), treinar um modelo de previsão e registrar todos os resultados com o **MLflow**.

## ⚙️ Pré-requisitos e Instalação

Para executar este script, você precisará ter as seguintes bibliotecas instaladas. Você pode instalá-las usando o `pip`:

```bash
pip install xgboost
pip install holidays
pip install matplotlib
pip install statsmodels
pip install scikit-learn
```

Este projeto também faz uso do **MLflow** para rastrear os experimentos, parâmetros, métricas e artefatos (como gráficos e modelos). A configuração do MLflow exige que a URI de rastreamento seja definida.

## 📁 Estrutura do Projeto

O script espera a seguinte estrutura de diretórios:

```
.
├── output/                     # Diretório de entrada: contém os arquivos CSV para modelagem
├── figures/                    # Diretório de saída: gráficos de previsão e árvores de decisão
├── prep_teste_output/          # Diretório de saída: dados de teste processados
├── output_metrics/             # Diretório de saída: métricas e importâncias das features
├── x_predict/                  # Diretório de saída: previsões futuras
├── xgboost_model.py            # O script principal
└── README.md
```

## 🚀 Como Executar

1.  Certifique-se de que os arquivos de dados (.csv) a serem modelados estão dentro do diretório `output/`.

2.  Configure a variável de ambiente `DATABRICKS_USER_EXPERIMENTS` com o caminho do experimento MLflow desejado.

3.  Execute o script no seu terminal:

    ```bash
    python xgboost_model.py
    ```

O script irá iterar sobre cada arquivo CSV no diretório `output/`, executar a pipeline de modelagem e salvar os resultados nos diretórios correspondentes.

## 📊 Processo de Modelagem

O script segue as seguintes etapas para cada arquivo de dados:

1.  **Carregamento de Dados**: Lê um arquivo CSV do diretório `output/`.
2.  **Engenharia de Features**:
      * Cria atributos de data e tempo (`month`, `day_of_month`, `is_weekend`, etc.).
      * Gera atributos de **lags** (valores de vendas de dias anteriores).
      * Cria atributos de **médias móveis** (`rolling_mean`) e **médias móveis exponenciais** (`ewm`).
      * Converte variáveis categóricas para formato *one-hot encoded*.
3.  **Divisão dos Dados**: Os dados são divididos de forma cronológica em conjuntos de **treinamento (70%)**, **validação (20%)** e **teste (10%)** para simular um cenário de previsão de série temporal.
4.  **Treinamento do Modelo**: Um modelo **XGBoost** é treinado no conjunto de treino. O treinamento utiliza **`early_stopping`** para otimizar o processo e evitar o *overfitting*.
5.  **Avaliação do Desempenho**:
      * O modelo faz previsões no conjunto de teste.
      * As métricas **MAE** (Erro Absoluto Médio) e **MSE** (Erro Quadrático Médio) são calculadas.
      * Um gráfico de comparação entre valores observados e previstos é gerado.
6.  **Interpretabilidade do Modelo**:
      * A **importância das *features*** é extraída e salva, mostrando quais variáveis mais contribuíram para o modelo.
      * São gerados gráficos da primeira árvore do modelo e gráficos **SHAP** para explicar as previsões.
7.  **Rastreamento do Experimento**: Todas as etapas, incluindo parâmetros do modelo, métricas de desempenho e artefatos visuais (gráficos, arquivos .txt), são registrados no **MLflow**, permitindo um rastreamento completo do experimento.
8.  **Previsão Futura**: O modelo treinado é utilizado para prever as vendas dos próximos 90 dias, e os resultados são salvos em um arquivo CSV.

----

# Script para Limpeza de Memória Cache

Este script Python, `clean.py`, é uma ferramenta para automatizar a execução de comandos `sudo` que requerem senha, especificamente a regra `memoria` definida em um `Makefile`. Ele usa a biblioteca `pexpect` para interagir com o terminal, fornecendo a senha automaticamente.

-----

### ⚙️ Pré-requisitos e Configuração

Para que este script funcione corretamente, você deve ter os seguintes componentes instalados e configurados:

1.  **Biblioteca `pexpect`**: Você pode instalá-la usando o pip:
    ```bash
    pip install pexpect
    ```
2.  **Variável de Ambiente `senha`**: O script obtém a senha de um ambiente de execução seguro. **Antes de rodar o script**, defina a variável de ambiente `senha` com a sua senha de usuário.
      * No Linux/macOS: `export senha="sua_senha_aqui"`
      * No Windows (CMD): `set senha="sua_senha_aqui"`
3.  **Arquivo `Makefile`**: O arquivo `Makefile` contendo a regra `memoria` deve estar no mesmo diretório do script.

-----

### 🚀 Como Funciona

1.  O script `clean.py` inicia um processo no terminal para executar o comando `make memoria`.
2.  A regra `memoria` no `Makefile` contém comandos que precisam de privilégios de superusuário (`sudo`) para limpar a memória cache do sistema.
3.  Quando o `sudo` solicita a senha, a biblioteca `pexpect` detecta o prompt e envia a senha contida na variável de ambiente `senha`.
4.  Após a execução bem-sucedida, o script exibe a saída do terminal e uma mensagem de confirmação.

-----

### Exemplo de Uso

1.  Configure sua senha como uma variável de ambiente:
    ```bash
    export senha="sua_senha_aqui"
    ```
2.  Certifique-se de que o arquivo `Makefile` com o conteúdo abaixo está no mesmo diretório.
3.  Execute o script:
    ```bash
    python clean.py
    ```

-----

### Conteúdo do `Makefile`

O script foi projetado para interagir especificamente com este `Makefile`. Ele contém a regra `memoria` que executa comandos para limpar o *cache* de página, o *cache* de dentes e os *inodes* da memória RAM, e então exibe o status da memória livre.

```
memoria:
	sudo bash -c 'echo 3 > /proc/sys/vm/drop_caches'
	sudo sysctl -w vm.drop_caches=3
	sudo free
```
