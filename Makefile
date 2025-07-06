clear:
	docker compose down
	docker stop $$(docker ps -aq) || true
	docker rm -f $$(docker ps -aq) || true
	docker rmi -f $$(docker images -aq) || true
	docker rmi -f $$(docker compose images -aq) || true
	docker volume rm $$(docker volume ls -q) || true
	docker volume rm $$(docker compose volume ls -q) || true
	
	docker system prune -a
	docker builder prune --force
	docker system prune --all --volumes --force
	sudo systemctl restart docker

	# limpa a memória do pc
	sudo bash -c 'echo 3 > /proc/sys/vm/drop_caches'
	sudo sysctl -w vm.drop_caches=3

pipeline:

	# docker compose build --no-cache meltano-api
	# docker compose build meltano-api
	# @export API_ENDPOINT=$(SalesOrderHeader)
	# docker compose up meltano-api

	# docker compose run --rm meltano-api meltano --environment=test select tap_adventureworksapi PurchaseOrderDetail
	# docker compose run --rm meltano-api -v $(pwd)/meltano.yml:/project/meltano.yml ...
	docker compose run --rm meltano-api meltano run tap_adventureworksapi target-jsonl # testar e descomentar aqui

    # meltano select tap-adventureworksapi PurchaseOrderDetail --exclude

	# docker compose run --rm meltano-api meltano --environment=test select tap_adventureworksapi SalesOrderHeader '*' && \
	# docker compose run --rm meltano-api meltano run tap_adventureworksapi target-jsonl


	
	# docker compose build --no-cache spark-db
	# docker compose build spark-db
	# docker compose up spark-db

	# docker compose build --no-cache azure-ingestion
	# # docker compose build azure-ingestion
	# docker compose up azure-ingestion
    
	# docker compose build databricks-upload
	# docker compose up --attach databricks-upload
	# docker compose down

init:
	@echo "🔧 Inicializando o banco de dados do Airflow..."
	docker compose run --rm airflow-init

## Sobe os serviços principais
up:
	@echo "🚀 Subindo os serviços do Airflow (webserver, scheduler, db)..."
	docker compose up -d airflow-webserver airflow-scheduler airflow-db

## Cria o usuário admin (ignora erro se já existir)
create-user:
	@echo "👤 Criando usuário admin (se necessário)..."
	sleep 15  # Aguarda webserver subir
	-docker exec airflow_webserver airflow users create \
		--username airflow \
		--firstname Admin \
		--lastname User \
		--role Admin \
		--email airflow@example.com \
		--password airflow || echo "⚠️  Usuário já existe. Pulando criação."

## Executa tudo em sequência
start: init up create-user
	@echo "---"
	@echo "✅ Airflow iniciado com sucesso!"
	@echo "🌐 Acesse: http://localhost:8080"
	@echo "🔐 Login: airflow | Senha: airflow"
	@echo "---"
