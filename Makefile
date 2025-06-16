memoria:
	sudo bash -c 'echo 3 > /proc/sys/vm/drop_caches'
	sudo sysctl -w vm.drop_caches=3

.PHONY: run_pipeline

pipeline:
	docker stop $$(docker ps -aq) || true
	docker rm -f $$(docker ps -aq) || true
	docker rmi -f $$(docker images -aq) || true
	docker volume rm $$(docker volume ls -q) || true

	# limpa a memória do pc
	sudo bash -c 'echo 3 > /proc/sys/vm/drop_caches'
	sudo sysctl -w vm.drop_caches=3

	# docker compose down

	# docker compose build --no-cache spark-db
	# docker compose up spark-db

	# docker compose build --no-cache azure-ingestion
	docker compose up azure-ingestion

    # DEU CERTO
	# docker compose build --no-cache spark-db
	# docker compose up spark-db