import pandas as pd
import os

def consolidar_previsoes_csv(diretorio_de_entrada):
    """
    Lê todos os arquivos CSV em um diretório, soma a coluna 'forecast_qty'
    de cada um e consolida os resultados em um único DataFrame.

    Args:
        diretorio_de_entrada (str): O caminho para a pasta contendo os arquivos CSV.

    Returns:
        pd.DataFrame: Um DataFrame consolidado com as colunas 'produto',
                      'pais' e 'total_previsao'.
    """
    
    # DataFrame para armazenar os resultados consolidados
    df_consolidado = pd.DataFrame(columns=['produto', 'pais', 'total_previsao'])

    # Lista todos os arquivos no diretório
    arquivos = os.listdir(diretorio_de_entrada)

    # Itera sobre cada arquivo
    for arquivo in arquivos:
        # Garante que estamos processando apenas arquivos CSV e que o nome segue o padrão
        if arquivo.endswith('.csv') and 'x_predict_' in arquivo:
            caminho_completo = os.path.join(diretorio_de_entrada, arquivo)

            try:
                # Extrai o nome do produto e o país do nome do arquivo
                nome_base = arquivo.replace('x_predict_', '').replace('.csv', '')
                partes_nome = nome_base.split('-')
                
                produto = partes_nome[0].replace('_', ' ')
                pais = partes_nome[1].replace('_', ' ')

                # Lê o arquivo CSV, ignorando a primeira linha de dados
                df_temp = pd.read_csv(caminho_completo)

                # Soma todos os valores da coluna 'forecast_qty'
                soma_total = df_temp['forecast_qty'].sum()

                # Cria uma nova linha no DataFrame consolidado
                nova_linha = pd.DataFrame([{
                    'produto': produto,
                    'pais': pais,
                    'total_previsao': soma_total
                }])
                
                # Adiciona a nova linha ao DataFrame consolidado
                df_consolidado = pd.concat([df_consolidado, nova_linha], ignore_index=True)

            except Exception as e:
                print(f"Erro ao processar o arquivo {arquivo}: {e}")
                continue

    return df_consolidado

def analisar_previsoes_por_pais(df_consolidado):
    """
    Analisa o DataFrame consolidado para identificar o país com a maior
    previsão de demanda e descreve os demais.

    Args:
        df_consolidado (pd.DataFrame): O DataFrame com as previsões consolidadas.

    Returns:
        pd.DataFrame: Um DataFrame com a soma das previsões por país.
    """
    if df_consolidado.empty:
        print("\nNenhum dado de previsão encontrado para análise por país.")
        return pd.DataFrame()

    total_por_pais = df_consolidado.groupby('pais')['total_previsao'].sum().reset_index()
    pais_maior_crescimento = total_por_pais.loc[total_por_pais['total_previsao'].idxmax()]
    
    print("\n" + "="*50)
    print("Análise de Crescimento da Demanda por País")
    print("="*50)
    print(f"O país com o maior crescimento de demanda previsto é: **{pais_maior_crescimento['pais']}**")
    print(f"Com um total de previsão de: **{pais_maior_crescimento['total_previsao']:.2f} unidades**\n")

    total_por_pais = total_por_pais.sort_values(by='total_previsao', ascending=False)
    
    print("Previsão de Crescimento dos Demais Países:")
    print(total_por_pais.to_string(index=False))
    print("="*50 + "\n")
    
    return total_por_pais

def analisar_previsoes_por_produto(df_consolidado):
    """
    Analisa o DataFrame consolidado para identificar o produto com a maior
    previsão de demanda global e descreve os demais.

    Args:
        df_consolidado (pd.DataFrame): O DataFrame com as previsões consolidadas.

    Returns:
        pd.DataFrame: Um DataFrame com a soma das previsões por produto.
    """
    if df_consolidado.empty:
        print("\nNenhum dado de previsão encontrado para análise por produto.")
        return pd.DataFrame()

    total_por_produto = df_consolidado.groupby('produto')['total_previsao'].sum().reset_index()
    produto_maior_crescimento = total_por_produto.loc[total_por_produto['total_previsao'].idxmax()]
    
    print("\n" + "="*50)
    print("Análise de Crescimento da Demanda Global por Produto")
    print("="*50)
    print(f"O produto com o maior crescimento de demanda global previsto é: **{produto_maior_crescimento['produto']}**")
    print(f"Com um total de previsão de: **{produto_maior_crescimento['total_previsao']:.2f} unidades**\n")

    total_por_produto = total_por_produto.sort_values(by='total_previsao', ascending=False)
    
    print("Previsão de Crescimento dos Demais Produtos:")
    print(total_por_produto.to_string(index=False))
    print("="*50 + "\n")
    
    return total_por_produto


def exportar_relatorios(df, nome_base_arquivo):
    """
    Exporta um DataFrame para os formatos CSV e Excel.
    """
    # Exporta para CSV
    df.to_csv(f'{nome_base_arquivo}.csv', index=False)
    print(f"Relatório '{nome_base_arquivo}.csv' salvo com sucesso!")
    
    # Exporta para Excel
    df.to_excel(f'{nome_base_arquivo}.xlsx', index=False)
    print(f"Relatório '{nome_base_arquivo}.xlsx' salvo com sucesso!")


# --- Exemplo de Uso ---
diretorio = './x_predict'

# 1. Concatena os arquivos
df_final = consolidar_previsoes_csv(diretorio)

# 2. Exibe o DataFrame final consolidado e o exporta
if not df_final.empty:
    print("\nDataFrame Consolidado:")
    print(df_final.to_string())
    exportar_relatorios(df_final, 'relatorio_previsoes_consolidadas')

# 3. Analisa e exporta o DataFrame de análise por país
df_analise_paises = analisar_previsoes_por_pais(df_final)
if not df_analise_paises.empty:
    exportar_relatorios(df_analise_paises, 'relatorio_analise_paises')

# 4. Realiza e exporta a análise global por produto
df_analise_produtos = analisar_previsoes_por_produto(df_final)
if not df_analise_produtos.empty:
    exportar_relatorios(df_analise_produtos, 'relatorio_analise_produtos')