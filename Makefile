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

start_pipeline:
	docker volume create shared-api # volume para dados da API
	docker compose build --no-cache meltano-api-xcon
	docker compose build --no-cache alpine

build_pipeline:
	docker volume create shared-api
	docker compose build meltano-api-xcon
	docker compose build alpine

	@echo "🔧 Inicializando o banco de dados do Airflow..."
	docker compose run --rm airflow-init

	@echo "🚀 Subindo os serviços do Airflow (webserver, scheduler, db)..."
	docker compose up -d airflow-webserver airflow-scheduler airflow-db redis airflow-worker
	@echo "🌐 Acesse: http://localhost:8080"
