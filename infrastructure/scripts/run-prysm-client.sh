#/bin/sh

/usr/src/ethereum/prysm/prysm.sh beacon-chain \
    --execution-endpoint=http://localhost:8551 \
    --prater \
    --datadir /usr/src/ethereum/data/consensus  \
    --jwt-secret=/usr/src/ethereum/data/jwt.hex \
    --genesis-state=genesis.ssz \
    --suggested-fee-recipient=0x01234567722E6b0000012BFEBf6177F1D2e9758D9
