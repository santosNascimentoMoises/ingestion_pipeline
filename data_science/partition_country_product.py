import pandas as pd
import numpy as np
import os

# Lista de pastas a serem criadas
pastas = [
    "figures",
    "output",
    "output_metrics",
    "prep_teste_output",
    "x_predict"
]

for pasta in pastas:
    os.makedirs(pasta, exist_ok=True)  # exist_ok=True evita erro se já existir

print("Pastas criadas/verificadas com sucesso.")

file = 'fact_sales.csv'

df = pd.read_csv(file)

df_analyse = pd.DataFrame(columns=['store','subcat','country_name','cities','file_output','qty_itens_sales','mean_nom_zeros_qty_itens_sales'])

def clean_string(text: str) -> str:
    if not isinstance(text, str):
        return text
    return (
        text.replace("&", "and")
            .replace("-", "_")
    )

def merge_with_date_template(df_sales, start_date, end_date):
    total_sales = df_sales.copy()
    idx = pd.date_range(start=start_date, end=end_date, freq='D')
    df_dates = pd.DataFrame({'date_day': idx})

    total_sales['date_day'] = pd.to_datetime(total_sales['date_day'])
    df_dates['date_day'] = pd.to_datetime(df_dates['date_day'])
    
    df_merged = pd.merge(df_dates, total_sales, on='date_day', how='left')
    
    # preencher NaNs com 0
    numeric_cols = df_merged.select_dtypes(include='number').columns
    df_merged[numeric_cols] = df_merged[numeric_cols].fillna(0)
    
    # ordena
    df_merged = df_merged.sort_values('date_day').reset_index(drop=True)
    
    return df_merged

for (country_name, subcat), group in df.groupby(["country_name","product_subcategory_name"]): # Removido as_index=False para um loop mais padrão

    # Limpa os nomes para usar nos arquivos e no DataFrame de análise
    country_name_clean = clean_string(country_name)
    subcat_clean = clean_string(subcat)

    # Gera o nome do arquivo de saída
    file_output = f'{subcat_clean.lower().replace(" ", "_")}-{country_name_clean.lower().replace(" ", "_")}'
    
    # AGREGA AS VENDAS DIÁRIAS APENAS PARA O GRUPO ATUAL
    daily_sales_group = group.groupby("date_day", as_index=False)["product_qty_day"].sum()

    # Mescla com o template de datas para preencher os dias sem vendas
    df_final = merge_with_date_template(daily_sales_group, "2011-05-31", "2014-06-30")
    
    # Adiciona as informações ao DataFrame de análise
    df_analyse.loc[len(df_analyse)] = {
        'subcat': subcat_clean.lower().replace(" ", "_"),
        'store': group['store_name'].unique(),
        'country_name': country_name_clean.lower().replace(" ", "_"),
        'cities': group['city'].unique(),
        'file_output': file_output,
        'qty_itens_sales': group['product_qty_day'].sum(),
        'mean_nom_zeros_qty_itens_sales': group.loc[group['product_qty_day'] != 0, 'product_qty_day'].mean() 
    }
    
    # Salva o arquivo CSV para o grupo atual
    df_final.to_csv("./output/" + file_output + ".csv", index=False)

print("Processo concluído!")
print(df_analyse)
df_analyse.to_csv('analyse_groups.csv', index=False)
