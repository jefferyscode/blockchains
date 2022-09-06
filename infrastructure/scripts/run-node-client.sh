#/bin/sh

run_node_client()
{
    local grpc_port=10000
    local libp2p_port=10001
    local jsonrpc_port=10002

    if [ -f shared/genesis.json -a -f data/node-id.txt ]; then
        echo "About to run node client."
        polygon-edge server --data-dir data/test-chain --chain shared/genesis.json --grpc-address :${grpc_port} --libp2p :${libp2p_port} --jsonrpc :${jsonrpc_port} --seal
    else
        echo "Need to initialize data folder and genesis file before running node client."
    fi
}

run_node_client
