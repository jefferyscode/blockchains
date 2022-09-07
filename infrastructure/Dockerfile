FROM golang:1.18

WORKDIR /usr/src/ethereum

# Install Geth and Prysm, some execution and consensus clients.
RUN mkdir -p prysm \
    && go install github.com/ethereum/go-ethereum/cmd/geth@v1.10.23 \
    && cd prysm \
    && curl https://raw.githubusercontent.com/prysmaticlabs/prysm/master/prysm.sh --output prysm.sh \
    && chmod +x prysm.sh

# Generate JWT secret.
RUN /usr/src/ethereum/prysm/prysm.sh beacon-chain generate-auth-secret \
    && mv jwt.hex /usr/src/ethereum/data

COPY ["scripts/run-geth-client.sh", "scripts/run-prysm-client.sh", "run-clients.sh", "./"]

CMD [ "sh", "run-clients.sh" ]
