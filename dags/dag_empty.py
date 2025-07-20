
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
        
        empty_operator = EmptyOperator(task_id="end_pipeline_db")

        empty_operator
