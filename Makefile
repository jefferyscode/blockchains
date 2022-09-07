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
	cat ${docker_file} | docker build --no-cache --rm -t ethereum-test -
#	docker build --rm -f ${docker_file} -t ethereum-test .

run:
	docker run --rm -it ethereum-test

get-node-id:
	docker run --rm -it ethereum-test cat node-id.txt

c-build:
	docker compose -f ${compose_file} -p ${project_name} build

c-up:
	docker compose -f ${compose_file} -p ${project_name} up

c-run:
	docker compose -f ${compose_file} -p ${project_name} run eth-node

c-exec:
	docker compose -f ${compose_file} -p ${project_name} exec eth-node sh

c-ps:
	docker compose -f ${compose_file} -p ${project_name} ps

c-logs:
	docker compose -f ${compose_file} -p ${project_name} logs eth-node

c-down:
	docker compose -f ${compose_file} -p ${project_name} down

c-help:
	docker compose -f ${compose_file} -p ${project_name} logs --help
