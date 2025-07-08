
from airflow import DAG
from airflow.decorators import task
from airflow.providers.docker.operators.docker import DockerOperator  # Operador que roda containers
from datetime import datetime
from pathlib import Path
from datetime import timedelta
import pendulum
from docker.types import Mount
import os
import logging

# Obtém o caminho absoluto a partir de um relativo
# 1. Defina o caminho ABSOLUTO no seu PC local
# HOST_OUTPUT_PATH = os.path.abspath(os.path.join(os.path.dirname(__file__), "../../output/api"))
HOST_OUTPUT_PATH = os.path.abspath("./shared")

# Define os parâmetros padrão para a DAG (retries, delay, etc.)
default_args = {
    "retries": 1,
    "retry_delay": timedelta(seconds=10),
}

default_args = {"owner": "airflow"}

with DAG(
    dag_id="ingest_databricks",
    start_date=datetime(2024, 1, 1),
    schedule_interval=None,
    catchup=False,
    tags=["meltano", "sdk", "xcom"]
) as dag:

    # @task(task_id="get_stream_metadata")
    # def get_stream_metadata():
    #     return {
    #         "name": "SalesOrderDetail",
    #         "path": "/SalesOrderDetail",
    #         "primary_keys": ["SalesOrderID", "SalesOrderDetailID"],
    #         "replication_key": "SalesOrderDetailID",
    #         "schema_filepath": "sales_order_detail.json"
    #     }
    name = 'SalesOrderHeader'

    from airflow.models import Variable

    @task(task_id="status_extrac_meltano")
    def get_status_extract_meltano():
        name_endpoint = name
        flag = Variable.get(f"flag_{name_endpoint}")

        if flag:
            print(f"ENDPOINT {name_endpoint} EXTRAIDO COM SUCESSO")
        else:
            print(f"ENDPOINT {name_endpoint} NÃO EXTRAIDO")

    status_extract_meltano = get_status_extract_meltano()

    @task(task_id="get_stream_metadata")
    def get_stream_metadata():

        return {
            "name": "SalesOrderHeader",
            "path": "/SalesOrderHeader",
            "primary_keys": ["SalesOrderID"],
            "replication_key": "ModifiedDate",
            "schema_filepath": "sales_order_header.json"
        }

    stream_info = get_stream_metadata()

    # docker_task = DockerOperator(
    #     task_id=f"executar_stream",
    #     image="meltano-api-xcon",  # imagem já buildada com a stream
    #     api_version="auto",
    #     auto_remove=True,
    #     command=f"meltano run tap_adventureworksapi target-jsonl",  # adapte se necessário
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

    alpine = DockerOperator(
        task_id=f"alpine",
        image="alpine",
        api_version="auto",
        auto_remove=True,
        command=f"python print.py",
        environment={
            **os.environ,  # Passa todas as variáveis do ambiente atual
            'VAR_EXTRA': 'valor_extra',  # Variáveis adicionais se necessário
            "STREAM_NAME": "{{ ti.xcom_pull(task_ids='get_stream_metadata')['name'] }}",
            "STREAM_PATH": "{{ ti.xcom_pull(task_ids='get_stream_metadata')['path'] }}",
            "STREAM_PK": "{{ ','.join(ti.xcom_pull(task_ids='get_stream_metadata')['primary_keys']) }}",
            "REPLICATION_KEY": "{{ ti.xcom_pull(task_ids='get_stream_metadata')['replication_key'] }}",
            "SCHEMA_FILEPATH": "{{ ti.xcom_pull(task_ids='get_stream_metadata')['schema_filepath'] }}"
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

    status_extract_meltano>>stream_info>>alpine#>>docker_task

# with open("/tmp/extract_status.flag", "w") as f:
#     f.write("success")

#  docker exec -it -u root ab0b70066dc0 /bin/bash
