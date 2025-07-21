from pyspark.sql import SparkSession
import os
import time
import logging
# from config import DATA_BASE_DIR, schema_list_extract
# from datetime import datetime
import sys
import pyarrow as pa
import pyarrow.parquet as pq

logger = logging.getLogger(__name__)

config_time_out = {

    "max_retries":3,
    "retry_delay":5  # segundos iniciais de espera
}

# configurando mensagens de log
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    handlers=[logging.StreamHandler(sys.stdout)],
    datefmt='%Y-%m-%d %H:%M:%S'
)

schema = os.getenv("SCHEMA_NAME")
table = os.getenv("TABLE_NAME")

# cria uma SparkSession usando o builder
def spark_builder():
    logger.info(f"[SPARK] SPARK BUILDER CONFIG")
    return SparkSession.builder \
        .appName("SPARK") \
        .config("spark.jars", "./mssql-jdbc-12.10.0.jre8.jar") \
        .master("local[2]") \
        .getOrCreate()

# função que realiza as etapas de extração de dados
def spark_extract(schema, table, config_time_out):

    try:
        logger.info(f"[SPARK] CONFIGURING SPARK BUILDER")
        spark = spark_builder()
        spark.sparkContext.setLogLevel("WARN")

    except Exception as e:
        logger.info(f"[SPARK] FAILED TO CONFIGURE SPARK BUILDER {e}")
        logger.info(f"[SPARK] CHECK FILE OR PATH OF *.JAR")
        logger.info(f"[SPARK] THE FILE: ./mssql-jdbc-12.10.0.jre8.jar")

    # informações do banco de dados
    port = 4563
    db = os.getenv('MSQL_DB_NAME')
    user = os.getenv('MSQL_DB_USER')
    password = os.getenv('MSQL_DB_PASSWORD')
    host = os.getenv('MSQL_DB_HOST')

    # configuração da string jbdc
    jdbc_url = f"jdbc:sqlserver://{host}:{port};databaseName={db};encrypt=true;trustServerCertificate=true"

    connection_properties = {
        "user": user,
        "password": password,
        "driver": "com.microsoft.sqlserver.jdbc.SQLServerDriver",
        "fetchsize": "20000"
    }

    max_retries = config_time_out["max_retries"]
    retry_delay = config_time_out["retry_delay"]
    
    for attempt in range(1, max_retries + 1):
        try:
            
            logger.info(f"[SPARK] TRYING TO EXTRACT {schema}.{table} - ATTEMPT {attempt}")
            df = spark.read.jdbc(
                url=jdbc_url,
                table=f"{schema}.{table}",
                properties=connection_properties
            )
            logger.info(f"[SPARK] SUCCESSFULLY EXTRACTED {schema}.{table}")
            break  # sucesso, sair do loop

        except Exception as e:
            logger.warning(f"[SPARK] FAILED TO EXTRACT {schema}.{table} ON ATTEMPT {attempt}: {e}")

            if attempt == max_retries:
                logger.error(f"[SPARK] ALL RETRIES FAILED FOR {schema}.{table}")
                raise e  # propaga a exceção após todas as tentativas falharem
            else:
                time.sleep(retry_delay)
                retry_delay *= 2  # backoff exponencial

    df = df.toPandas()
    
    output_path = f"/app/output/db/{table}.jsonl"

    df.to_json(output_path, orient="records", lines=True, force_ascii=False)

    logger.info(f"[SPARK] SUCESS COMPLETED {schema}.{table}")
    logger.info(output_path.replace('/app/output/db/',''))

if __name__ == "__main__":
    spark_extract(schema, table, config_time_out)
