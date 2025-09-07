from databricks import sql
import pandas as pd
import os

connection = sql.connect(
                        server_hostname = os.getenv("DATABRICKS_SERVER_HOSTNAME_FULL"),
                        http_path = os.getenv("DATABRICKS_HTTP_PATH"),
                        access_token = os.getenv("DATABRICKS_ACCESS_TOKEN")
                    )

cursor = connection.cursor()
cursor.execute("SELECT * FROM adventure_works.data_science.fact_sales_day_with_calendar")

# Retorna todos os resultados como lista de tuplas
rows = cursor.fetchall()

columns = [col[0] for col in cursor.description]  # nomes das colunas
df = pd.DataFrame(rows, columns=columns)

df.to_csv("fact_sales.csv", index=False)
