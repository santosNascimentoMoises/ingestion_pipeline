
from airflow import DAG
from datetime import datetime
from datetime import timedelta
from airflow.operators.empty import EmptyOperator
from airflow.sensors.external_task import ExternalTaskSensor


# Define os parâmetros padrão para a DAG (retries, delay, etc.)
default_args = {
    # "retries": 1,
    "retry_delay": timedelta(seconds=10),
    "owner": "airflow"
}


with DAG(
    dag_id="teste_encadear_dags",
    start_date=datetime(1990, 1, 1),
    schedule_interval="@daily",
    catchup=False,
    tags=["meltano", "sdk", "databricks"],
    default_args=default_args
) as dag:
        
        espera_raw = ExternalTaskSensor(
        task_id='espera_dag',
        external_dag_id='el_extract_ingest_databricks',
        external_task_id='run_databricks_job_raw_to_bronze',
        allowed_states=['success'],
        failed_states=['failed', 'skipped'],
        mode='poke',  # ou 'reschedule', dependendo da estratégia
        timeout=60 * 60,
        poke_interval=60,
        execution_delta=timedelta(minutes=0)  # ou execution_date_fn para mais controle
    )
        empty_operator = EmptyOperator(task_id="end_pipeline_db")

        espera_raw >> empty_operator
