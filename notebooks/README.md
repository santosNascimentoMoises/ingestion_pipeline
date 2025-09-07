### README: Pipeline de Engenharia de Features e Preparação de Dados no Databricks

Este notebook do Databricks foi desenvolvido para realizar a **engenharia de features** e a **preparação de dados** para um projeto de análise e modelagem de vendas. Ele utiliza a API do Spark para extrair, transformar e carregar (ETL) dados de tabelas existentes no Databricks, preparando-os para o consumo por modelos de *machine learning*.

---

### 📊 Etapas do Processamento de Dados

O notebook segue uma sequência lógica de células para preparar os dados:

1.  **Carregamento de Dados**: Carrega duas tabelas-chave do esquema `adventure_works`:
    * `fct_sales_for_ds_analysis`: Tabela de fatos de vendas com informações diárias.
    * `dim_address`: Tabela de dimensão com detalhes de endereço.
    * `dim_dates`: Tabela de dimensão com informações de calendário.
2.  **Junção de Tabelas (`JOIN`)**:
    * As tabelas `df_sales` e `df_addres` são unidas com base no `address_id` para enriquecer os dados de vendas com informações geográficas (país, cidade).
    * Em seguida, o `df_merge` é unido com o `df_dates` na coluna de data, para incorporar atributos de calendário (dia da semana, mês, etc.) e garantir que a série temporal seja completa.
3.  **Limpeza e Filtragem**:
    * O DataFrame é filtrado para incluir apenas as vendas entre a data mínima e máxima presentes nos dados.
    * **Colunas duplicadas** são identificadas e removidas para evitar erros de processamento em etapas futuras.
    * Colunas irrelevantes como `address_id` e `date_order_date` são removidas, pois já foram utilizadas para as junções.
4.  **Conversão de Tipos**: Todas as colunas do DataFrame final são convertidas para o tipo `string`.
5.  **Armazenamento em Tabela Delta**: O DataFrame final e limpo é salvo em uma nova tabela **Delta** no Databricks, chamada `adventure_works.data_science.fact_sales_day_with_calendar`.
6.  **Segmentação de Clientes**: O DataFrame é dividido em dois subgrupos com base no tipo de cliente (`person_type`):
    * **`SC` (Store Customer)**: Clientes do tipo B2B.
    * **`IN` (Individual)**: Clientes do tipo B2C.
7.  **Salvamento de Dados Segmentados**: Cada subgrupo é salvo em uma tabela Delta separada para análise individualizada:
    * `fact_sales_SC_day_with_calendar`
    * `fact_sales_IN_day_with_calendar`
8.  **Exportação para CSV**: O subgrupo de clientes "Individual" (`df_merge_in`) é convertido para um DataFrame do Pandas e exportado como um arquivo CSV, permitindo o uso em ambientes de desenvolvimento local.
