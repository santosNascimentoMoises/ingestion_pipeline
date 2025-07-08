
from airflow import DAG
from airflow.decorators import task
from airflow.providers.docker.operators.docker import DockerOperator  # Operador que roda containers
from datetime import datetime
from pathlib import Path
from datetime import timedelta
import pendulum
from docker.types import Mount
import os
from airflow.utils.task_group import TaskGroup
from airflow.sensors.external_task import ExternalTaskSensor
from config.config_streams_meltano_api import get_streams_select

# Define os parâmetros padrão para a DAG (retries, delay, etc.)
default_args = {
    "retries": 5,
    "retry_delay": timedelta(seconds=10),
    "owner": "airflow"
}

# default_args = {"owner": "airflow"}

STREAMS_METADATA = get_streams_select()

# STREAMS_METADATA = {
#     "SalesOrderHeader": {
#         "path": "/SalesOrderHeader",
#         "primary_keys": ["SalesOrderID"],
#         "replication_key": "ModifiedDate",
#         "schema_filepath": "sales_order_header.json"
#     },
#     "SalesOrderDetail": {
#         "path": "/SalesOrderDetail",
#         "primary_keys": ["SalesOrderID", "SalesOrderDetailID"],
#         "replication_key": "SalesOrderDetailID",
#         "schema_filepath": "sales_order_detail.json"
#     },
# }

with DAG(
    dag_id="dag_extract_meltano_ingest_databricks",
    start_date=datetime(2024, 1, 1),
    schedule_interval=None,
    catchup=False,
    tags=["meltano", "sdk", "databricks"],
    default_args=default_args
) as dag:

    with TaskGroup(group_id="grupo_meltano_extract_endpoint") as extract_group:
        
        extract_tasks = {}

        for name, metadata in STREAMS_METADATA.items():

            docker_task_extract = DockerOperator(
                task_id=f"extract_{name}",
                image="meltano-api-xcon",
                api_version="auto",
                auto_remove=True,
                command=f"meltano run tap_adventureworksapi target-jsonl",  # adapte se necessário
                environment={

                    **os.environ,
                    "STREAM_NAME": name,
                    "STREAM_PATH": metadata["path"],
                    "STREAM_PK": ",".join(metadata["primary_keys"]),
                    "REPLICATION_KEY": metadata["replication_key"],
                    "SCHEMA_FILEPATH": metadata["schema_filepath"]

                },

                mount_tmp_dir=False,
                mounts=[
                    Mount(
                        source='shared-api',
                        target="/app/output",
                        type="volume",
                        ),

                    ],
                
                working_dir='/app',
                docker_url="unix://var/run/docker.sock",
                network_mode="bridge",

                retries=5,  # sobrescreve os 2 definidos no default_args
                retry_delay=timedelta(minutes=1),  # também sobrescreve

            )
            extract_tasks[name] = docker_task_extract
    
    with TaskGroup(group_id="grupo_databricks_ingest_endpoint") as ingest_group:

        for name, metadata in STREAMS_METADATA.items():
            
            @task(task_id=f"databricks_ingest_{name}")
            def ingest_stream(name=name):
                print(f"Iniciando ingestão para o endpoint: {name}")
                # Simulação da ingestão no Databricks
                return f"Ingestão do stream {name} concluída."

            # Conecta extração ao ingestion (apenas se extração tiver sucesso)
            extract_tasks[name] >> ingest_stream()
