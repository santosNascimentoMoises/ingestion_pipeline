import logging

logger = logging.getLogger("csv_logger")
logger.setLevel(logging.INFO)
fh = logging.FileHandler("csvs_modelados.log")
logger.addHandler(fh)

def registrar_csv(file_path):
    logger.info(f"Modelado: {file_path}")

# exemplo
registrar_csv("./datasets/vendas_2014.csv")

