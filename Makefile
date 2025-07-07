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

alpine_print:
	docker compose build --no-cache alpine

pdown:
	docker compose down -v meltano-api-xcon

pipeline:
	docker volume create shared-api # volume para dados da API
	# docker compose build --no-cache meltano-api
	# docker compose build meltano-api
	# docker compose up meltano-api

	docker compose build --no-cache meltano-api-xcon
	# docker compose build meltano-api-xcon
	# docker compose up meltano-api-xcon
		
	# docker compose build --no-cache spark-db
	# docker compose build spark-db
	# docker compose up spark-db

	# docker compose build --no-cache azure-ingestion
	# # docker compose build azure-ingestion
	# docker compose up azure-ingestion
    
	# docker compose build databricks-upload
	# docker compose up --attach databricks-upload
	# docker compose down

down:
	docker compose down -v airflow-webserver airflow-scheduler airflow-db redis airflow-worker airflow-init
init:
	@echo "🔧 Inicializando o banco de dados do Airflow..."
	docker compose run --rm airflow-init

## Sobe os serviços principais
up:
	@echo "🚀 Subindo os serviços do Airflow (webserver, scheduler, db)..."
	docker compose up -d airflow-webserver airflow-scheduler airflow-db redis airflow-worker
	@echo "🌐 Acesse: http://localhost:8080"
