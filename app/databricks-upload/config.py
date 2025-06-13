import os
from pathlib import Path
from dotenv import load_dotenv

# Carrega variáveis do .env
load_dotenv()


POSTGRES_DATA_DIR = os.getenv("POSTGRES_DATA_DIR")
API_DATA_DIR = os.getenv("API_DATA_DIR")

# depois vai ser só as pastas do app do docker
# POSTGRES_DATA_DIR = r'/app/raw/postgres'
# API_DATA_DIR = r'/app/raw/api'