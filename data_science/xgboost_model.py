"""
pip install xgboost
pip install holidays
pip install matplotlib
pip install statsmodels
pip install scikit-learn
"""

import os
import holidays
import numpy as np
import pandas as pd
import xgboost as xgb
import matplotlib.pyplot as plt
from sklearn.metrics import mean_squared_error, mean_absolute_error
import logging
import mlflow
# import mlflow.sklearn
import shap
from clean import comand

user_experiments = os.getenv("DATABRICKS_USER_EXPERIMENTS")
mlflow.set_tracking_uri("databricks")
mlflow.set_experiment(user_experiments)

#cria logs dos arquivos carregados e modelados
logger = logging.getLogger(__name__)
logger = logging.getLogger("csv_logger")
logger.setLevel(logging.INFO)
fh = logging.FileHandler("csvs_modelados.log")
logger.addHandler(fh)

def registrar_csv(file):
    logger.info(f"{file}")

lag_list = [2,5,15,30,50,90,100]

# Função
def cria_atributos_lag(df, lag_list):
    for lag in lag_list:
        df['lag' + str(lag)] = df.product_qty_day.shift(lag)
    return df

windows_list = [2,5,15,30,50,60,90]

# Função
def cria_atributo_rolling_mean(df, windows_list):
    for window in windows_list:
        df['vendas_rolling_mean' + str(window)] = df.product_qty_day.rolling(window).mean().shift(1).values
    return df

# atributos exponentially weight mean (ewm)
# Lags
lags = [2,5,30,60,90]
# Lista de alfas
alpha_list = [0.8, 0.7, 0.5]
# Função
def cria_atributos_ewm(df, alphas, lags):
    for alpha in alphas:
        for lag in lags:
            df['sales_ewm_alpha_' + str(alpha).replace(".","") + 
            "_lag_" + str(lag)] = df.product_qty_day.transform(
            lambda x: x.shift(lag).ewm(alpha = alpha).mean())
    return df

def lista_holidays(df):
    
    df['data'] = pd.to_datetime(df.data)
    
    min_year = df.data.min().year
    max_year = df.data.max().year
    
    years_list = pd.period_range(min_year, max_year, freq = 'Y')
    
    list_of_holidays = []
    
    for year in years_list:
        list_of_holidays.append(holidays.US(years = int(str(year))).keys())
        
    holiday_list = [item for sublist in list_of_holidays for item in sublist]
    
    return holiday_list

def cria_atributos_date_time(df):
    
    df['data'] = pd.to_datetime(df['date_day'])
    df['month'] = df['data'].dt.month
    df['day_of_month'] = df['data'].dt.day
    df['day_of_year'] = df['data'].dt.dayofyear
    df['week_of_year'] = df['data'].dt.isocalendar().week
    df['day_of_week'] = df['data'].dt.weekday + 1
    df['year'] = df['data'].dt.year 
    df['is_weekend'] = (df['data'].dt.weekday >= 5).astype(int)
    df['start_of_month'] = df['data'].dt.is_month_start.astype(int)
    df['end_of_month'] = df['data'].dt.is_month_end.astype(int)

    return df

lista = [i.replace('.csv','') for i in os.listdir('./output')]
lista_output = [i.replace('xgboost_prediction_','').replace('.png','') for i in os.listdir('./figures')]

for file in lista:
        
        comand('make memoria')

        df_model_metrics = pd.DataFrame(columns=['file_output','model_mae','model_mse','mean_3_mae','mean_3_mse'])

        file_name = file

        dados = pd.read_csv('./output/' + file_name  + '.csv')

        df = cria_atributos_date_time(dados)

        df = df.set_index('data')

        df = cria_atributos_lag(df, lag_list)
        
        df = cria_atributo_rolling_mean(df, windows_list)

        df = cria_atributos_ewm(df, alpha_list, lags)

        # Converte variáveis categóricas em variáveis dummy aplicando One-Hot Encoding
        df = pd.get_dummies(df, columns = ['day_of_week', 'month'])

        # preparação dos dados
        df['itens_vendidos'] = df["product_qty_day"].values

        # Colunas sem informações úteis ou com informações já derivadas serão descartadas.
        cols = [col for col in df.columns if col not in ['data', "itens_vendidos", "year", "date_day","product_qty_day"]]

        # Separa X e Y
        X = df[cols]
        Y = df['itens_vendidos']

        x_teste_file = f'./prep_teste_output/X_{file_name}.csv'
        X.to_csv(x_teste_file)

        # print(df)
        Y_3_mean = df.copy()
        Y_3_mean['date_day'] = pd.to_datetime(Y_3_mean['date_day'])
        Y_3_mean.set_index('date_day', inplace=True)
        # print(Y_3_mean)
        Y_3_mean['ma_3m'] = Y_3_mean['itens_vendidos'].rolling('90D').mean()

        n_amostras = len(X)

        # 2. Definir os pontos de corte para a divisão 70% (treino), 20% (val), 10% (teste)
        ponto_corte_treino = int(n_amostras * 0.7)
        ponto_corte_val = int(n_amostras * 0.9)  # 70% (treino) + 10% (validação)

        # O conjunto de treino contém os primeiros 90% dos dados (o passado)
        X_treino = X.iloc[:ponto_corte_treino]
        y_treino = Y.iloc[:ponto_corte_treino]

        # O conjunto de validação contém os próximos 20% (o futuro próximo)
        X_val = X.iloc[ponto_corte_treino:ponto_corte_val]
        y_val = Y.iloc[ponto_corte_treino:ponto_corte_val]

        # O conjunto de teste contém os últimos 10% (o futuro distante)
        X_teste = X.iloc[ponto_corte_val:]
        y_teste = Y.iloc[ponto_corte_val:]

        y_teste_3_months_mean = Y_3_mean.iloc[ponto_corte_val:]

        modelo = xgb.XGBRegressor(
            n_estimators=3000,
            learning_rate=0.04,
            max_depth=7,
            min_child_weight=3,
            subsample=0.8,
            colsample_bytree=0.8,
            reg_alpha=0.1,
            reg_lambda=1,
            early_stopping_rounds=50,
            eval_metric=["rmse","mae"],
            random_state=42
        )

        with mlflow.start_run(run_name=file_name):

            mlflow.log_artifact(x_teste_file)

            # 1. Log de parâmetros do modelo
            mlflow.log_param("n_estimators", modelo.n_estimators)
            mlflow.log_param("learning_rate", modelo.learning_rate)
            mlflow.log_param("early_stopping_rounds", modelo.early_stopping_rounds)
            mlflow.log_param("eval_metric", modelo.eval_metric)

            # 2. Fit do modelo (já feito, mas você poderia treinar aqui dentro)
            modelo.fit(
                X_treino,
                y_treino,
                eval_set=[(X_val, y_val)],
                verbose=True
            )

            # 3. Previsões
            previsoes = modelo.predict(X_teste)

            # desfazendo log
            # previsoes = np.expm1(previsoes)
            # y_teste = np.expm1(y_teste)
            #FIXME

            # 4. Log de métricas
            mae = mean_absolute_error(previsoes, y_teste.values)
            mse = mean_squared_error(previsoes, y_teste.values)

            mae_3_mean = mean_absolute_error(y_teste, y_teste_3_months_mean['ma_3m'].values)
            mse_3_mean = mean_squared_error(y_teste, y_teste_3_months_mean['ma_3m'].values)

            mlflow.log_metric("mae", mae)
            mlflow.log_metric("mse", mse)

            # 5. Criar figura
            fig = plt.figure(figsize=(12,6))
            plt.plot(y_teste.values, label='Valores Observados')
            plt.plot(previsoes, label='Valores Previstos')
            plt.plot(y_teste_3_months_mean['ma_3m'].values, label = 'Média móvel 3 meses')
            plt.legend(loc='best')
            plt.title(f"XGBoost Prediction - {file_name}")

            # 6. Salvar figura temporariamente
            fig_path = f"./figures/xgboost_prediction_{file_name}.png"
            plt.savefig(fig_path)
            plt.close(fig)

            # 7. Log da figura no MLflow
            mlflow.log_artifact(fig_path)

            # 8. Log do modelo treinado
            mlflow.xgboost.log_model(modelo, name="xgboost_model")

            plt.close()

            # === 1. Importância das variáveis (weight + gain) ===
            importancias = modelo.get_booster().get_score(importance_type='weight')
            print("Importância (weight):", importancias)

            # 1. Extrair importâncias do modelo treinado
            importancias = modelo.get_booster().get_score(importance_type='gain')

            # 2. Ordenar por importância
            importancias_ordenadas = dict(sorted(importancias.items(), key=lambda x: x[1], reverse=True))

            # 3. Salvar em arquivo TXT
            txt_path = f"./output_metrics/feature_importances_{file_name}.txt"
            with open(txt_path, "w") as f:
                f.write("Feature Importances (XGBoost - importance_type='gain')\n")
                f.write("="*60 + "\n")
                for feature, importancia in importancias_ordenadas.items():
                    f.write(f"{feature}: {importancia:.6f}\n")

            # 4. Registrar no MLflow
            mlflow.log_artifact(txt_path)

            # === 2. Estrutura da primeira árvore ===
            plt.figure(figsize=(30, 15))
            xgb.plot_tree(modelo, num_trees=0)
            plt.title("Árvore 0 do XGBoost")
            fig_path_tree = f"./figures/xgboost_tree_0_{file_name}.png"
            plt.savefig(fig_path_tree)
            plt.close()

            mlflow.log_artifact(fig_path_tree)

            # === 3. SHAP values ===
            explainer = shap.TreeExplainer(modelo)
            shap_values = explainer.shap_values(X_teste)

            # Summary Plot SHAP
            fig = plt.figure(figsize=(16, 10))
            shap.summary_plot(shap_values, X_teste, show=False)
            fig_path_shap = f"./figures/shap_summary_{file_name}.png"
            plt.savefig(fig_path_shap, bbox_inches="tight")
            plt.close(fig)

            mlflow.log_artifact(fig_path_shap)

            # === 4. SHAP Interaction values ===
            shap_interaction = explainer.shap_interaction_values(X_teste)

            fig = plt.figure(figsize=(16, 10))
            shap.summary_plot(shap_interaction, X_teste, show=False)
            fig_path_shap_inter = f"./figures/shap_interaction_summary_{file_name}.png"
            plt.savefig(fig_path_shap_inter, bbox_inches="tight")
            plt.close(fig)

            mlflow.log_artifact(fig_path_shap_inter)

            df_model_metrics.loc[len(df_model_metrics)] = {
                'file_output': file_name,
                'model_mae': mae,
                'model_mse': mse,
                'mean_3_mae': mae_3_mean,
                'mean_3_mse': mse_3_mean,
            }

            print('XGBoost MAE = ', mean_absolute_error(previsoes, y_teste.values))
            print('XGBoost MSE = ', mean_squared_error(previsoes, y_teste.values))
            df_model_metrics.to_csv(f'./output_metrics/model_metrics_resum_{file_name}.csv')

            future_days = 90

            preds = []

            hist = df.copy()
            future_preds = pd.DataFrame()

            for step in range(future_days):
                last_row = hist.iloc[-1:].copy()
                last_date = pd.to_datetime(last_row['date_day'].values[0])
                next_date = last_date + pd.Timedelta(days=1)

                # 1. Criar linha base
                future = pd.DataFrame({'date_day': [next_date]})
                future = cria_atributos_date_time(future)
                # future['is_holiday'] = 0

                # 2. Recalcular lags e rollings a partir do histórico
                for lag in lag_list:
                    if len(hist) >= lag:
                        future[f'lag{lag}'] = hist['product_qty_day'].iloc[-lag]
                    else:
                        future[f'lag{lag}'] = np.nan

                for window in windows_list:
                    if len(hist) >= window:
                        future[f'vendas_rolling_mean{window}'] = (
                            hist['product_qty_day'].iloc[-window:].mean()
                        )
                    else:
                        future[f'vendas_rolling_mean{window}'] = np.nan

                for alpha in alpha_list:
                    for lag in lags:
                        if len(hist) > lag:
                            future[f'sales_ewm_alpha_{str(alpha).replace(".","")}_lag_{lag}'] = (
                                hist['product_qty_day']
                                .shift(lag)
                                .ewm(alpha=alpha)
                                .mean()
                                .iloc[-1]
                            )
                        else:
                            future[f'sales_ewm_alpha_{str(alpha).replace(".","")}_lag_{lag}'] = np.nan

                # 3. Garantir que as colunas estão na mesma ordem do treino
                future = future.reindex(columns=X.columns)

                # 4. Previsão
                y_hat = modelo.predict(future)[-1]

                # 5. Atualizar histórico
                row_for_hist = future.copy()
                row_for_hist['product_qty_day'] = y_hat
                hist = pd.concat([hist, row_for_hist], ignore_index=False)

                # 6. Acumular no DF de previsões
                pred_row = pd.DataFrame({
                    "date_day": [next_date],
                    "forecast_qty": [y_hat]
                })

                future_preds = pd.concat([future_preds, pred_row], ignore_index=True)

            save_x_test_final = f'./x_predict/x_predict_{file_name}.csv'
            future_preds.to_csv(save_x_test_final, index=None)
            mlflow.log_artifact(save_x_test_final)
            mlflow.end_run()
            registrar_csv(file)
