import requests
import json
import os
import logging

logger = logging.getLogger(__name__)

# configurações de conexão com o job configurado no databrix
JOB_ID = os.getenv('JOB_ID')
DATABRICKS_TOKEN = os.getenv('DATABRICKS_ACCESS_TOKEN')
DATABRICKS_INSTANCE = os.getenv('DATABRICKS_INSTANCE')

# URL do endpoint
url = f"https://{DATABRICKS_INSTANCE}/api/2.1/jobs/run-now"

# headers de autenticação
headers = {
    "Authorization": f"Bearer {DATABRICKS_TOKEN}",
    "Content-Type": "application/json"
}

# payload da requisição
payload = {
    "job_id": JOB_ID
}

# executando a requisição
logger.info(f"[JOB DATABRICKS] START REQUEST TO JOB")
response = requests.post(url, headers=headers, data=json.dumps(payload))

# tratamento da resposta
if response.status_code == 200:
    run_id = response.json().get("run_id")
    logger.info(f"[JOB DATABRICKS] SUCESS START JOB{run_id}")

else:
    logger.info(f"[JOB DATABRICKS] FAILED TO RUN JOB ON DATABRICKS {response}")
    logger.info(f"[JOB DATABRICKS] STATUS CODE {response.status_code}")
    logger.info(f"[JOB DATABRICKS] {response.json().get("run_id")}")
