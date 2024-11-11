#!/bin/bash

# Configuration variables
EMD_HOME="$HOME/.sentry/.allorad"
CONFIG_PATH="${EMD_HOME}/config"
SERVICE_NAME="sentry-allorad.service"
DATA_PATH="${EMD_HOME}/data"

RPC_ADDRESS="http://88.198.70.23:26757"
RPC_SERVERS="http://88.198.70.23:26757,http://162.55.65.137:26757,http://51.81.109.67:26657,http://135.181.65.94:45657,http://34.85.251.36:26657,http://35.245.78.162:26657,http://34.69.129.28:26657,http://65.21.16.237:26657,http://35.217.49.11:26657,http://135.181.10.62:26657,http://162.55.245.254:30657,http://65.108.8.250:30657,http://103.88.234.61:26657,http://176.9.44.125:26657,http://185.144.99.11:46657,http://65.108.29.234:27657,http://45.92.11.222:26657,http://91.108.227.176:26657,http://40.160.12.223:26657,http://65.21.102.153:17657,http://116.202.211.111:26657,http://142.132.180.52:26657,http://15.204.101.153:26657,http://15.204.101.154:26657,http://144.76.90.14:26657,http://80.66.81.169:26657,http://168.119.38.47:26657,http://80.66.89.81:26657,http://80.66.85.98:26657"
LOG_PATH="/home/ubuntu/snapshots/mainnet/logs/state_sync/allorad_log.txt"

mkdir -p $(dirname ${LOG_PATH})

# Helper function to get current date in a specific format
now_date() {
    echo -n $(TZ=":Europe/Moscow" date '+%Y-%m-%d_%H:%M:%S')
}

# Logging function
log_this() {
    local logging="$@"
    printf "|$(now_date)| $logging\n" | tee -a ${LOG_PATH}
}

# Main execution
log_this "Start\n"
log_this "Stopping ${SERVICE_NAME}"
sudo systemctl stop ${SERVICE_NAME}
SERVICE_STOP_STATUS=$?
log_this "Service stop status: $SERVICE_STOP_STATUS"

log_this "Resetting data file"
cp ${DATA_PATH}/priv_validator_state.json ${EMD_HOME}/priv_validator_state.json.bak
rm -rf ${DATA_PATH}/*
mv ${EMD_HOME}/priv_validator_state.json.bak ${DATA_PATH}/priv_validator_state.json

LATEST_HEIGHT=$(curl -s $RPC_ADDRESS/block | jq -r .result.block.header.height)
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000))
TRUST_HASH=$(curl -s "$RPC_ADDRESS/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$RPC_SERVERS,$RPC_SERVERS\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" ${CONFIG_PATH}/config.toml


log_this "Starting ${SERVICE_NAME}"
sudo systemctl start ${SERVICE_NAME}
SERVICE_START_STATUS=$?
log_this "Service start status: $SERVICE_START_STATUS"

log_this "Done\n---------------------------------------------------------\n"
