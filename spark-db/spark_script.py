from pyspark.sql import SparkSession
import os
from config import DATA_BASE_DIR, schema_list_extract
import logging

# configurando mensagens de log
logging.basicConfig(
    level=logging.INFO,
    format='[%(asctime)s] [%(levelname)s] %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'
)

logger = logging.getLogger(__name__)

# cria uma SparkSession usando o builder
def spark_builder():
    logger.info(f"[SPARK] SPARK BUILDER")
    return SparkSession.builder \
        .appName("SPARK") \
        .config("spark.jars", "./mssql-jdbc-12.10.0.jre8.jar") \
        .master("local[2]") \
        .getOrCreate()

# função que realiza as etapas de extração de dados
def spark_extract():

    spark = spark_builder()

    # informações do banco de dados
    port = 4563
    db = os.getenv('MSQL_DB_NAME')
    user = os.getenv('MSQL_DB_USER')
    password = os.getenv('MSQL_DB_PASSWORD')
    host = os.getenv('MSQL_DB_HOST')

    # configuração da string jbdc
    jdbc_url = f"jdbc:sqlserver://{host}:{port};databaseName={db};encrypt=true;trustServerCertificate=true"

    # leitura dos schemas do banco de dados
    schemas_df = spark.read \
        .format("jdbc") \
        .option("url", jdbc_url) \
        .option("query", "SELECT name as schema_name FROM sys.schemas") \
        .option("batchsize", "1000") \
        .option("driver" , "com.microsoft.sqlserver.jdbc.SQLServerDriver") \
        .option("user", user) \
        .option("password", password) \
        .load()

    schemas_list = [row.schema_name for row in schemas_df.collect()]
    print(schemas_list)

    connection_properties = {
        "user": user,
        "password": password,
        "driver": "com.microsoft.sqlserver.jdbc.SQLServerDriver"
    }

    for schema in schemas_list:

        # condicional para carregar somente o necessário (préconfigurado em config.py)
        if schema in schema_list_extract: 

            # query para pegar os nomes ddas tabelas dos schemas
            tables_query = f"""
            (SELECT table_name 
            FROM INFORMATION_SCHEMA.TABLES 
            WHERE TABLE_SCHEMA = '{schema}' AND TABLE_TYPE = 'BASE TABLE') AS tables
            """

            tables_df = spark.read.jdbc(
                url=jdbc_url,
                table=tables_query,
                properties=connection_properties
            )

            tables_df.show()

            tables = [row.table_name for row in tables_df.collect()]
        
            for table in tables:
                print(f"Exporting {schema}.{table}")
                output_path = f"{DATA_BASE_DIR}/{schema}-{table}"
                
                # leitura da tabela
                df = spark.read.jdbc(
                    url=jdbc_url,
                    table=f"{schema}.{table}",
                    properties=connection_properties
                )
                
                # salva o dado em formato parquet
                df.coalesce(1).write.parquet(path=output_path,mode="overwrite")

if __name__ == "__main__":
    spark_extract()
