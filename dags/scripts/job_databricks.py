import requests
import json
import os
import logging

logger = logging.getLogger(__name__)

def trigger_databricks_job(job_id=None, token=None, instance=None):
    """
    Dispara um job no Databricks via API REST.

    Args:
        job_id (str): ID do job no Databricks. Se None, busca da variável de ambiente JOB_ID.
        token (str): Token de acesso ao Databricks. Se None, busca da variável de ambiente DATABRICKS_ACCESS_TOKEN.
        instance (str): Instância do Databricks (host). Se None, busca da variável de ambiente DATABRICKS_INSTANCE.

    Returns:
        dict: Resposta JSON da API se sucesso.
        None: Se falha na requisição.
    """

    job_id = job_id or os.getenv('JOB_ID')
    token = token or os.getenv('DATABRICKS_ACCESS_TOKEN')
    instance = instance or os.getenv('DATABRICKS_INSTANCE')

    instance = instance+'.cloud.databricks.com'

    if not all([job_id, token, instance]):
        logger.error("Parâmetros insuficientes: job_id, token e instance são obrigatórios.")
        return None

    url = f"https://{instance}/api/2.1/jobs/run-now"
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    payload = {"job_id": job_id}

    try:
        logger.info("[JOB DATABRICKS] Iniciando requisição para disparar job")
        response = requests.post(url, headers=headers, data=json.dumps(payload))
        response.raise_for_status()

        run_id = response.json().get("run_id")
        logger.info(f"[JOB DATABRICKS] Job iniciado com sucesso. Run ID: {run_id}")
        return response.json()

    except requests.exceptions.RequestException as e:
        logger.error(f"[JOB DATABRICKS] Falha ao iniciar job: {e}")
        return None
