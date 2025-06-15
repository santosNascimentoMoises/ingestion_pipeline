import pandas as pd
import os
from config import DATA_BASE_DIR, API_DATA_DIR
from data_list import file_list_rename

print("fui no docker azure")
print(API_DATA_DIR)

os.chdir(DATA_BASE_DIR)
file =  "arquivo_teste.csv"
df = pd.read_csv(file)
print(df)




files = file_list_rename()
print(files)
