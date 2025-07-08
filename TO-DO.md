# TO-DO CHECKPOINT-3 :writing_hand:
- [X] :+1: consegui extrair todas as APIs :muscle::muscle:
- [X] :+1: consegui fazer o airflow rodar um simples comando
- [ ] vou ter que fazer uma imagem customizada para instalar as dependencias
    talvez vale a pena verificar se existe algum comando que instale os requerimentos
- [ ] após isso, configurar dockeroperator pra rodar os demais dockers (meltano,spark-db,databricks)
- [ ] testar a ingestão do databricks
- [ ] instalar dbt core e configurar projeto
- [ ] modelar a stg e uma dim bem simples
- [ ] modelar o restante
    - descrever... fct, dim, etc...

# AL DAY COMANDS
- source .venv/bin/activate
- source .env


# se der
- [ ] quem sabe plotar alguns gráficos no notebook databricks


## comandos de teste databricks_cli via docker compose
docker compose up --build databricks
docker exec -it databricks_cli python /app/upload_json.py
