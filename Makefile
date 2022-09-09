project_name=ethereum-prototype-blockchain
docker_file=infrastructure/Dockerfile
compose_file=infrastructure/docker-compose.yml

install:
	npm install

compile:
	npx hardhat compile

deploy:
	npx hardhat deploy

build:
	cat ${docker_file} | docker build --no-cache --rm -t polygon-test -
#	docker build --rm -f ${docker_file} -t polygon-test .

run:
	docker run --rm -it polygon-test

get-node-id:
	docker run --rm -it polygon-test cat node-id.txt

c-build:
	docker compose -f ${compose_file} -p ${project_name} build

c-up:
	sh infrastructure/scripts/start-polygon-local-network.sh

c-run:
	docker compose -f ${compose_file} -p ${project_name} run --entrypoint=/bin/bash node_1

c-ps:
	docker compose -f ${compose_file} -p ${project_name} ps

c-logs:
	docker compose -f ${compose_file} -p ${project_name} logs node_3

c-down:
	docker compose -f ${compose_file} -p ${project_name} down

c-help:
	docker compose -f ${compose_file} -p ${project_name} logs --help
