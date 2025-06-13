import pandas as pd
import os
from config import POSTGRES_DATA_DIR, API_DATA_DIR

print("fui no docker azure")
print(API_DATA_DIR)

os.chdir(POSTGRES_DATA_DIR)
file =  "arquivo_teste.csv"
df = pd.read_csv(file)
print(df)