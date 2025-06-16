import requests
import json
import os

# configurações de conexão com o job configurado no databrix
JOB_ID = os.getenv('JOB_ID')
DATABRICKS_TOKEN = os.getenv('DATABRICKS_TOKEN')
DATABRICKS_INSTANCE = os.getenv('DATABRICKS_INSTANCE')
DATABRICKS_CLUSTER_ID = os.getenv('DATABRICKS_CLUSTER_ID')

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
response = requests.post(url, headers=headers, data=json.dumps(payload))

# tratamento da resposta
if response.status_code == 200:
    run_id = response.json().get("run_id")
    print(f"Job iniciado com sucesso. Run ID: {run_id}")
