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

down:
	docker compose down

build_pipeline:
	docker volume create shared-api
	docker volume create shared-db
	docker compose build meltano-api-xcon
	docker compose build databricks-ingest
	docker compose build spark-db

	@echo "🔧 Inicializando o banco de dados do Airflow..."
	docker compose run --rm airflow-init

	@echo "🚀 Subindo os serviços do Airflow (webserver, scheduler, db)..."
	docker compose up -d airflow-webserver airflow-scheduler airflow-db redis airflow-worker airflow-triggerer
	@echo "🌐 Acesse: http://localhost:8080"
