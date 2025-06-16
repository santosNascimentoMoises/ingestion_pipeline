import os

# diretório dos dados do banco de dados
DATA_BASE_DIR = '/app/output/bd/' 

# diretório dos dados da api
API_DATA_DIR = '/app/output/api/'

# configuração da string de conexão com a AZURE
storage_account_name = os.getenv('AZURE_STORAGE_ACCOUNT_NAME')
sas_token = os.getenv('AZURE_STORAGE_ACCOUNT_KEY')

connection_string = (
    "DefaultEndpointsProtocol=https;"
    f"AccountName={storage_account_name};"
    f"AccountKey={sas_token};"
    "EndpointSuffix=core.windows.net")

container_name_string = os.getenv('AZURE_CONTAINER_NAME')

