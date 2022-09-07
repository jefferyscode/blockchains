#/bin/sh

# TODO: Run these 2 scripts simultaneously.
set -m
./run-geth-client.sh &
./run-prysm-client.sh
