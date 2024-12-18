#!/bin/bash

# Configuration variables
EMD_HOME="$HOME/.sentry/.kava"
SERVICE_NAME="sentry-kava.service"

CONFIG_PATH="${EMD_HOME}/config"
ADDRBOOK_JSON="${CONFIG_PATH}/addrbook.json"
DATA_PATH="${EMD_HOME}/data"
RPC_ADDRESS="https://rpc.kava.io:443"
RPC_SERVERS="https://rpc.kava.io:443,https://kava-rpc.polkachu.com:443,https://kava-mainnet-rpc.autostake.com:443,https://rpc.data.kava.io:443,https://kava-rpc.ibs.team:443,https://rpc-kava-01.stakeflow.io:443,https://kava-rpc.publicnode.com:443"
LOG_PATH="/home/ubuntu/snapshots/mainnet/logs/state_sync/kava_log.txt"
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
BLOCK_HEIGHT=$((LATEST_HEIGHT - 500))
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
