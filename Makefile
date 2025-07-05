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


# caso queira montar e rodar os dockers em separado

# build:
# 	docker build -t $(IMAGE_NAME) .

# run:
# 	docker run --rm -v "$(PWD)/output/api:/app/api_output/api" $(IMAGE_NAME)

# compose-run:
# 	docker-compose run --rm meltano

# clean:
# 	rm -rf output/api/*

# o comando mudaria: make build (só builda); make compose-run (roda)