from databricks.sdk import WorkspaceClient
import os
import logging

logging.basicConfig(
    level=logging.INFO,
    format='[%(asctime)s] [%(levelname)s] %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'
)

logger = logging.getLogger(__name__)

FILE_NAME = 'exemplo.json'

dbfs_path = "dbfs:/Volumes/adventure_works/raw/raw_api/"+FILE_NAME
dbfs_dir = "dbfs:/Volumes/adventure_works/raw/raw_api/"

host = f"https://{os.getenv('DATABRICKS_INSTANCE')}.cloud.databricks.com"
token = os.getenv('DATABRICKS_ACCESS_TOKEN')

w = WorkspaceClient(
    host=host,
    token=token
)

# with open(FILE_NAME, 'rb') as f:
#     w.dbfs.upload(dbfs_path, f)

try:
    with open(FILE_NAME, 'rb') as f:
        w.dbfs.upload(dbfs_path, f, overwrite=True)

    logger.info(f"[DATABRIX INGEST] SUCCESS FILE UPLOADED: {FILE_NAME}")

except Exception as e:
    print(f"[FALHA] Erro durante upload: {str(e)}")
