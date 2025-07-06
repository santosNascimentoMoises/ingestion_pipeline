from airflow.operators.python import PythonOperator
from airflow import DAG
# from airflow.decorators import dag,task  # Importa o decorador para criar DAGs
from airflow.providers.docker.operators.docker import DockerOperator  # Operador que roda containers
from datetime import timedelta

from datetime import datetime
import sys
import os

from scripts.teste_alterar_yml import yml_stream_change

default_args = {
    "retries": 1,
    "retry_delay": timedelta(seconds=10),
}
# Garante que o script possa ser importado
sys.path.append(os.path.join(os.path.dirname(__file__), 'scripts'))


with DAG(
    dag_id="executa_script_local",
    start_date=datetime(2024, 1, 1),
    schedule_interval=None,
    catchup=False,
    tags=["exemplo", "python"]
) as dag:
    
    task = PythonOperator(
        task_id="executando_script_stream_change",
        python_callable=yml_stream_change
    )

# @task
# def run():
#     yml_stream_change()

# # def yml_stream():

# #     tarefa_executa_script = PythonOperator(
# #         task_id="executa_meu_script",
# #         python_callable=yml_stream_change,
# #         command='echo "teste ok"'
# #     )

# #     tarefa_executa_script()

# dag = run()
