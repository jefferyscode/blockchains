#/bin/sh

geth --ropsten \
    --datadir "/usr/src/ethereum/data/execution" \
    --http --http.api="eth,web3,net" \
    --authrpc.vhosts="localhost" \
    --authrpc.jwtsecret=/usr/src/ethereum/data/jwt.hex
