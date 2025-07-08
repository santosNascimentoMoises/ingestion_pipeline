
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

# Define os parâmetros padrão para a DAG (retries, delay, etc.)
default_args = {
    "retries": 1,
    "retry_delay": timedelta(seconds=10),
}

default_args = {"owner": "airflow"}

STREAMS_METADATA = {
    "SalesOrderHeader": {
        "path": "/SalesOrderHeader",
        "primary_keys": ["SalesOrderID"],
        "replication_key": "ModifiedDate",
        "schema_filepath": "sales_order_header.json"
    },
    "SalesOrderDetail": {
        "path": "/SalesOrderDetail",
        "primary_keys": ["SalesOrderID", "SalesOrderDetailID"],
        "replication_key": "SalesOrderDetailID",
        "schema_filepath": "sales_order_detail.json"
    },
}

with DAG(
    dag_id="extract_meltano",
    start_date=datetime(2024, 1, 1),
    schedule_interval=None,
    catchup=False,
    tags=["meltano", "sdk"]
) as dag:

    with TaskGroup(group_id="grupo_meltano_extract_endpoint") as tg:

        for name, metadata in STREAMS_METADATA.items():

            docker_task = DockerOperator(
            task_id=f"extract_{name}",
            image="meltano-api-xcon",  # imagem já buildada com a stream
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
            network_mode="bridge"
        )

    # alpine = DockerOperator(
    #     task_id=f"alpine",
    #     image="alpine",
    #     api_version="auto",
    #     auto_remove=True,
    #     command=f"python print.py",
    #     environment={
    #         **os.environ,  # Passa todas as variáveis do ambiente atual
    #         'VAR_EXTRA': 'valor_extra',  # Variáveis adicionais se necessário
    #         "STREAM_NAME": "{{ ti.xcom_pull(task_ids='get_stream_metadata')['name'] }}",
    #         "STREAM_PATH": "{{ ti.xcom_pull(task_ids='get_stream_metadata')['path'] }}",
    #         "STREAM_PK": "{{ ','.join(ti.xcom_pull(task_ids='get_stream_metadata')['primary_keys']) }}",
    #         "REPLICATION_KEY": "{{ ti.xcom_pull(task_ids='get_stream_metadata')['replication_key'] }}",
    #         "SCHEMA_FILEPATH": "{{ ti.xcom_pull(task_ids='get_stream_metadata')['schema_filepath'] }}"
    #     },
    #     mount_tmp_dir=False,
    #     mounts=[
    #         Mount(
    #             source='shared-api',
    #             target="/app/output",
    #             type="volume",
    #             ),

    #         ],
    #     working_dir='/app',
    #     docker_url="unix://var/run/docker.sock",
    #     network_mode="bridge"
    # )

    # stream_info>>alpine#>>docker_task

    # name_endpoint = name
    # from airflow.models import Variable
    # Variable.set(f"flag_{name_endpoint}", True)


#  docker exec -it -u root ab0b70066dc0 /bin/bash