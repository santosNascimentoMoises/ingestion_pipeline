from airflow import DAG
from airflow.sensors.external_task import ExternalTaskSensor
from airflow.operators.python import PythonOperator
from airflow.sensors.time_delta import TimeDeltaSensorAsync
from datetime import datetime, timedelta
from scripts.job_databricks import trigger_databricks_job
from airflow.utils.state import DagRunState

default_args = {
    'owner': 'data-engineering',
    'depends_on_past': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=1),
    'start_date': datetime(2025, 1, 1),
}

with DAG(
    dag_id='job_databricks_rest',
    schedule_interval=None,
    default_args=default_args,
    catchup=False,
) as dag:

    # Espera que a DAG chamada 'dag_produtora' finalize com sucesso
    end_el_databricks = ExternalTaskSensor(
        task_id='end_el_databrickss',
        external_dag_id='el_extract_ingest_databricks',
        external_task_id=None,  # Pode aguardar DAG inteira ou task específica
        mode='reschedule',
        poke_interval=60,
        timeout=60 * 60,
        allowed_states=[DagRunState.SUCCESS],
        failed_states=[DagRunState.FAILED],
    )

    def executar_job_databricks():
        resultado = trigger_databricks_job()
        if resultado is None:
            raise Exception("Erro ao disparar job Databricks.")
        
    # Job databricks para gerar Bronze no formato delta
    run_databricks_job = PythonOperator(
        task_id='run_databricks_job_raw_to_bronze',
        python_callable=executar_job_databricks,
    )

    end_el_databricks >> run_databricks_job
