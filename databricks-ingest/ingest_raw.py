from databricks.sdk import WorkspaceClient
import os
import logging

# configurando mensagens de log
logging.basicConfig(
    level=logging.INFO,
    format='[%(asctime)s] [%(levelname)s] %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'
)

logger = logging.getLogger(__name__)

os.chdir('/app/output')

FILE_NAME = os.getenv("FILE_NAME")
FILE_TYPE = os.getenv("FILE_TYPE")
VOLUME_PATH = os.getenv("VOLUME_PATH")

# diretório RAW no databricks
# ex: "dbfs:/Volumes/adventure_works/raw/raw_api/file.parquet"
dbfs_path = VOLUME_PATH+FILE_NAME+FILE_TYPE

host = f"https://{os.getenv('DATABRICKS_INSTANCE')}.cloud.databricks.com"
token = os.getenv('DATABRICKS_ACCESS_TOKEN')

w = WorkspaceClient(
    host=host,
    token=token
)

try:
    with open(FILE_NAME+FILE_TYPE, 'rb') as f:
        w.dbfs.upload(dbfs_path, f, overwrite=True)

    logger.info(f"[DATABRIX INGEST] SUCCESS FILE UPLOADED: {FILE_NAME}")

except Exception as e:
    print(f"[FALHA] Erro durante upload: {str(e)}")
    # "debug"
    # logger.info(f"[DATABRIX INGEST] URL: {dbfs_path}")
    # logger.info(f"[DATABRIX INGEST] FILE: {FILE_NAME}")
    # logger.info(f"[DATABRIX INGEST] FILE TYPE: {FILE_TYPE}")
    # logger.info(f"[DATABRIX INGEST] FILE HOST: {host}")

os.remove(FILE_NAME+FILE_TYPE)

# "debug" de diretórios dentro do docker
# print('diretório atual app tem:')
# print(os.listdir())
# os.chdir("./output/api")
# print(os.listdir())
