
from airflow import DAG
# from airflow.decorators import task
from airflow.providers.docker.operators.docker import DockerOperator  # Operador que roda containers
from datetime import datetime
from datetime import timedelta
from airflow.operators.python import PythonOperator
# import pendulum
from docker.types import Mount
import os
from airflow.utils.task_group import TaskGroup
# from airflow.sensors.external_task import ExternalTaskSensor
from config.config_streams_meltano_api import get_streams_select
from config.config_schema_table_db import get_schema_table_select


# Define os parâmetros padrão para a DAG (retries, delay, etc.)
default_args = {
    # "retries": 1,
    "retry_delay": timedelta(seconds=10),
    "owner": "airflow"
}

#------------------------ DEFINIÇÃO DOS DIRETORIOS
# source: volume de despejo dos dados
source_api_data_path = 'shared-api'
source_db_data_path = 'shared-db'

# target: diretorio no container
target_meltano_data_path = '/app/output'
target_spark_data_path = '/app/output/db'
target_databricks_data_path = '/app/output'

#------------------------ DEFINIÇÃO DOS DOCKER_OPERATORS
docker_meltano_extract = {
    "image": "meltano-api-xcon",
    "api_version": "auto",
    "network_mode": "bridge",
    "auto_remove": True,
    "mount_tmp_dir": False,
    "command": f"meltano run tap_adventureworksapi target-jsonl",
    "working_dir": "/app",
    "docker_url":"unix://var/run/docker.sock",
}

docker_databricks_ingest = {
    "image": "databricks-ingest",
    "api_version": "auto",
    "docker_url": "unix://var/run/docker.sock",
    "network_mode": "bridge",
    "auto_remove": True,
    "mount_tmp_dir": False,
    "command": f"python ingest_raw.py",
    "working_dir": "/app",
}

docker_spark_extract = {
    "image": "spark-db",
    "api_version": "auto",
    "network_mode": "bridge",
    "auto_remove": True,
    "mount_tmp_dir": False,
    "command": f"python spark_script.py",
    "working_dir": "/app",
    "docker_url":"unix://var/run/docker.sock",
}

#------------------------ DEFINIÇÃO DA FUNÇÃO DE TASKS
def ingest_databricks_task(
    name: str,
    metadata: dict,
    source_path: str,
    target_path: str
):

    return DockerOperator(
        task_id=f"ingest_{name}",
        **docker_databricks_ingest,
        environment={
            **os.environ,
            "FILE_NAME": name,
            "VOLUME_PATH": metadata["volume_path"],
            "FILE_TYPE": metadata["data_type"]
            },

        mounts=[
            Mount(
                source=source_path,
                target=target_path,
                type="volume",
            ),
        ],
        
    )

def extract_meltano_task(
    name: str,
    metadata: dict,
    source_path: str,
    target_path: str
    ):

    return DockerOperator(
        task_id=f"extract_{name}",
        **docker_meltano_extract,
        environment={
            **os.environ,
            "STREAM_NAME": name,
            "STREAM_PATH": metadata["path"],
            "STREAM_PK": ",".join(metadata["primary_keys"]),
            "REPLICATION_KEY": metadata["replication_key"],
            "SCHEMA_FILEPATH": metadata["schema_filepath"]
            },

        mounts=[
            Mount(
                source=source_path,
                target=target_path,
                type="volume",
            ),
        ],
    )

def extract_spark_task(
    name: str,
    metadata: dict,
    source_path: str,
    target_path: str
    ):

    return DockerOperator(
        task_id=f"extract_{name}",
        **docker_spark_extract,
        environment={
            **os.environ,
            "TABLE_NAME": name,
            "SCHEMA_NAME": metadata["schema"],
            },

        mounts=[
            Mount(
                source=source_path,
                target=target_path,
                type="volume",
            ),
        ],
        task_concurrency=4,  # no máximo 4 instâncias desta task 
    )

#------------------------ DEFINIÇÃO DOS STREAMS (EDNPOINTS E SCHEMA.TABLE)
STREAMS_METADATA_API = get_streams_select()
STREAMS_METADATA_DB = get_schema_table_select()

with DAG(
    dag_id="el_extract_ingest_databricks",
    start_date=datetime(2024, 1, 1),
    schedule_interval=None,
    catchup=False,
    tags=["meltano", "sdk", "databricks"],
    default_args=default_args
) as dag:

    with TaskGroup(group_id="meltano_extract_endpoint") as extract_group:
        
        extract_meltano_tasks = {}

        for name, metadata in STREAMS_METADATA_API.items():

            task_extract = extract_meltano_task(
                name,
                metadata,
                source_api_data_path,
                target_meltano_data_path
            )

            extract_meltano_tasks[name] = task_extract

    with TaskGroup(group_id="spark_extract_db") as extract_group:
        
        extract_spark_tasks = {}

        for name, metadata in STREAMS_METADATA_DB.items():

            task_extract = extract_spark_task(
                name,
                metadata,
                source_db_data_path,
                target_spark_data_path
            )

            extract_spark_tasks[name] = task_extract

    with TaskGroup(group_id="databricks_ingest_raw_api") as ingest_group:
        
        ingest_api_tasks = {}

        for name, metadata in STREAMS_METADATA_API.items():

            docker_task_ingest_api = ingest_databricks_task(
                name,
                metadata,
                source_api_data_path,
                target_databricks_data_path
            )

            ingest_api_tasks[name] = docker_task_ingest_api

            extract_meltano_tasks[name] >> ingest_api_tasks[name]

    with TaskGroup(group_id="databricks_ingest_raw_db") as ingest_group:

        ingest_db_tasks = {}

        for name, metadata in STREAMS_METADATA_DB .items():

            docker_task_ingest_db = ingest_databricks_task(
                name,
                metadata,
                source_db_data_path,
                target_databricks_data_path
            )

            ingest_db_tasks[name] = docker_task_ingest_db

            extract_spark_tasks[name] >> ingest_db_tasks[name]

