#/bin/sh

project_name=ethereum-prototype-blockchain
compose_file=infrastructure/docker-compose.yml
bootnodes_in_network=2
network_nodes=("node_1" "node_2" "node_3" "node_4")
grpc_ports=(10000 20000 30000 40000)
libp2p_ports=(10001 20001 30001 40001)
jsonrpc_ports=(10002 20002 30002 40002)

get_node_id()
{
    local service_name=$1
    local node_id=$(docker compose -f ${compose_file} -p ${project_name} run ${service_name} cat data/node-id.txt)

    echo $node_id
}

get_miltiaddr_connection_string()
{
    local service_name=$1
    local port=$2
    local node_id=$(get_node_id $service_name)
    local miltiaddr_connection_string="/dns4/${service_name}/tcp/${port}/p2p/${node_id}"

    echo $miltiaddr_connection_string
}

run_clients()
{
    local nodes_in_network=${#network_nodes[@]}

    for ((i = 0 ; i < nodes_in_network ; i++ ));
    do
        local service_name=${network_nodes[$i]}
        local grpc_port=${grpc_ports[$i]}
        local libp2p_port=${libp2p_ports[$i]}
        local jsonrpc_port=${jsonrpc_ports[$i]}

        docker compose -f ${compose_file} -p ${project_name} run --detach ${service_name} bash -c "polygon-edge server --data-dir data/test-chain --chain shared/genesis.json --grpc-address :${grpc_port} --libp2p :${libp2p_port} --jsonrpc :${jsonrpc_port} --seal"
    done
}

generate_shared_genesis_file()
{
    local bootnode_1_service_name=${network_nodes[0]}
    local bootnode_1_multiaddr=$(get_miltiaddr_connection_string ${network_nodes[0]} ${libp2p_ports[0]})
    local bootnode_2_multiaddr=$(get_miltiaddr_connection_string ${network_nodes[1]} ${libp2p_ports[1]})

    docker compose -f ${compose_file} -p ${project_name} run ${bootnode_1_service_name} bash -c "[ ! -f 'shared/genesis.json' ] && polygon-edge genesis --consensus ibft --ibft-validators-prefix-path test-chain- --bootnode ${bootnode_1_multiaddr} --bootnode ${bootnode_2_multiaddr} && mv genesis.json shared && echo 'Created shared genesis.json file.'"
}

initialize_data_folders()
{
    local node_id_file="data/node-id.txt"
    local nodes_in_network=${#network_nodes[@]}

    for ((i = 0 ; i < nodes_in_network ; i++ ));
    do
        local service_name=${network_nodes[$i]}

        docker compose -f ${compose_file} -p ${project_name} run ${service_name} bash -c "[ ! -f \"$node_id_file\" ] && polygon-edge secrets init --data-dir data/test-chain --json | jq .node_id | tr -d '\"' > ${node_id_file} && echo 'Initialized data folders for ${service_name}.'"
    done
}

start_containers()
{
    docker compose -f ${compose_file} -p ${project_name} up --detach
}

main()
{
    initialize_data_folders
    generate_shared_genesis_file
    start_containers
}

main
