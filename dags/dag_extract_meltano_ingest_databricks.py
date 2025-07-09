
from airflow import DAG
from airflow.decorators import task
from airflow.providers.docker.operators.docker import DockerOperator  # Operador que roda containers
from datetime import datetime
from datetime import timedelta
# import pendulum
from docker.types import Mount
import os
from airflow.utils.task_group import TaskGroup
from airflow.sensors.external_task import ExternalTaskSensor
from config.config_streams_meltano_api import get_streams_select

# Define os parâmetros padrão para a DAG (retries, delay, etc.)
default_args = {
    # "retries": 1,
    "retry_delay": timedelta(seconds=10),
    "owner": "airflow"
}

STREAMS_METADATA_API = get_streams_select()

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

        for name, metadata in STREAMS_METADATA_API.items():

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
    
    with TaskGroup(group_id="teste_grupo_databricks_ingest") as ingest_group:
        
        ingest_tasks = {}

        for name, metadata in STREAMS_METADATA_API.items():

            docker_task_ingest_api = DockerOperator(
                task_id=f"ingest_{name}",
                image="databricks-ingest",
                api_version="auto",
                auto_remove=True,
                command=f"python ingest_raw.py",
                environment={

                    **os.environ,
                    "FILE_NAME": name,
                    "VOLUME_PATH": metadata["volume_path"],
                    "FILE_TYPE": metadata["data_type"]

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

                # retries=5,  # sobrescreve os 2 definidos no default_args
                retry_delay=timedelta(minutes=1),  # também sobrescreve

            )
            ingest_tasks[name] = docker_task_ingest_api


            # Conecta extração ao ingestion (apenas se extração tiver sucesso)
            extract_tasks[name] >> ingest_tasks[name]
