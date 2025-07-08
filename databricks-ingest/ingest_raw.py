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

# nome do arquivo
FILE_NAME = 'exemplo.json'

# diretório RAW no databricks
dbfs_path = "dbfs:/Volumes/adventure_works/raw/raw_api/"+FILE_NAME

host = f"https://{os.getenv('DATABRICKS_INSTANCE')}.cloud.databricks.com"
token = os.getenv('DATABRICKS_ACCESS_TOKEN')

w = WorkspaceClient(
    host=host,
    token=token
)

try:
    with open(FILE_NAME, 'rb') as f:
        w.dbfs.upload(dbfs_path, f, overwrite=True)

    logger.info(f"[DATABRIX INGEST] SUCCESS FILE UPLOADED: {FILE_NAME}")

except Exception as e:
    print(f"[FALHA] Erro durante upload: {str(e)}")

# "debug" de diretórios dentro do docker
# print('diretório atual app tem:')
# print(os.listdir())
# os.chdir("./output/api")
# print(os.listdir())
