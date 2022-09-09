FROM golang:1.18

WORKDIR /usr/src/polygon

# Install Polygon Edge CLI and jq, a JSON processor.
RUN git clone https://github.com/0xPolygon/polygon-edge.git \
    && cd polygon-edge/ \
    && go build -o polygon-edge main.go \
    && mv polygon-edge /usr/local/bin \
    && apt-get update && apt-get install -y \
        jq \
    && rm -rf /var/lib/apt/lists/*

COPY scripts/run-node-client.sh .
RUN chmod +x run-node-client.sh

CMD [ "sh", "run-node-client.sh" ]
