clean-docker:
	docker stop $$(docker ps -aq) || true
	docker rm -f $$(docker ps -aq) || true
	docker rmi -f $$(docker images -aq) || true
	docker volume rm $$(docker volume ls -q) || true
	docker network prune -f

memoria:
	sudo bash -c 'echo 3 > /proc/sys/vm/drop_caches'
	sudo sysctl -w vm.drop_caches=3

.PHONY: run_pipeline

pipeline:
	docker stop $$(docker ps -aq) || true
	docker rm -f $$(docker ps -aq) || true
	docker rmi -f $$(docker images -aq) || true
	docker volume rm $$(docker volume ls -q) || true

	sudo bash -c 'echo 3 > /proc/sys/vm/drop_caches'
	sudo sysctl -w vm.drop_caches=3

	# docker compose down && docker compose up --build
	docker compose down
	docker compose build --no-cache spark-db
	docker compose up spark-db
	# docker compose run --rm databricks-upload
	# docker compose run --rm azure-ingestion