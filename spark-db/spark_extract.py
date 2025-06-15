# pip install pyspark
from pyspark.sql import SparkSession
import os
from config import DATA_BASE_DIR, schema_list_extract

def spark_builder():
    print('SPARK BUILDER')
    return SparkSession.builder \
        .appName("SPARK") \
        .config("spark.jars", "./mssql-jdbc-12.10.0.jre8.jar") \
        .master("local[2]") \
        .getOrCreate()

def spark_extract():

    spark = spark_builder()

    port = 4563
    db = os.getenv('MSQL_DB_NAME')
    user = os.getenv('MSQL_DB_USER')
    password = os.getenv('MSQL_DB_PASSWORD')
    host = os.getenv('MSQL_DB_HOST')

    # container_name = os.getenv('AZURE_CONTAINER_NAME')
    # storage_account_name = os.getenv('AZURE_STORAGE_ACCOUNT_NAME')
    # sas_token = os.getenv('AZURE_STORAGE_ACCOUNT_KEY')

    jdbc_url = f"jdbc:sqlserver://{host}:{port};databaseName={db};encrypt=true;trustServerCertificate=true"
    schemas_df = spark.read \
        .format("jdbc") \
        .option("url", jdbc_url) \
        .option("query", "SELECT name as schema_name FROM sys.schemas") \
        .option("batchsize", "10000") \
        .option("driver" , "com.microsoft.sqlserver.jdbc.SQLServerDriver") \
        .option("user", user) \
        .option("password", password) \
        .load()

    # schemas_df.show()

    schemas_list = [row.schema_name for row in schemas_df.collect()]
    print(schemas_list)

    connection_properties = {
        "user": user,
        "password": password,
        "driver": "com.microsoft.sqlserver.jdbc.SQLServerDriver"
    }

    for schema in schemas_list:
            if schema in schema_list_extract:
                # Correct query to get tables - no schema qualification needed for INFORMATION_SCHEMA
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
                    
                    # Read the table
                    df = spark.read.jdbc(
                        url=jdbc_url,
                        table=f"{schema}.{table}",
                        properties=connection_properties
                    )
                    
                    df.coalesce(1).write.parquet(path=output_path,mode="overwrite")
                    files_extract = True
