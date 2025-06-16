import os
import glob
from config import DATA_BASE_DIR

# função que renomeia os arquivos parquet carregados
# por padrão os arquivos vem com padrão de prefixo "part-00000"
def file_list_rename():
    file_list=[]
    file_name = []

    # lista as pastas presentes no diretório
    path_list = [path for path in os.listdir(DATA_BASE_DIR)]
     
    for path in path_list:

        # encontra o arquivo part-00000... .parquet
        part_files = glob.glob(f"{DATA_BASE_DIR}/{path}/part-00000*")

        if part_files:

            # pegar o primeiro arquivo encontrado
            original_file = part_files[0]
            
            # novo nome do arquivo (mesmo nome da pasta com extensão .parquet)
            new_file_path = f"{DATA_BASE_DIR}/{path}.parquet"

            # renomear o arquivo
            os.rename(original_file, new_file_path)

            file_list.append(new_file_path)
            file_name.append(f'{path}.parquet')

if __name__ == "__main__":
    file_list_rename()
    print('ARQUIVOS RENOMEADOS')
