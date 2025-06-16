from azure.storage.blob import BlobClient
from config import DATA_BASE_DIR, container_name_string, connection_string
import os

# muda para o diretório
os.chdir(DATA_BASE_DIR)

# lista de arquivos parquet a serem enviados para o banco de dados.
files = [parquet_file for parquet_file in os.listdir() if '.parquet' in parquet_file]

# função upload para realizar o carregamento de dados na Azure
def upload(file,save_name):

    blob_client = BlobClient.from_connection_string(
        conn_str=connection_string,
        container_name=container_name_string,
        blob_name=f'teste/{save_name}'
        )

    # abertuda do arquivo local e envio para azure blob
    with open(f'{file}','rb') as data:
        response = blob_client.upload_blob(data, blob_type="BlockBlob",overwrite=True)
        print("Última modificação:", response['last_modified'])

# chama a função upload
for file in files:
    upload(file,file)
