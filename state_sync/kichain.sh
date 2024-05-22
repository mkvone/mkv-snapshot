#!/bin/bash

# Configuration variables
EMD_HOME="$HOME/.kid"
CONFIG_PATH="${EMD_HOME}/config"
SERVICE_NAME="kid.service"
RPC_ADDRESS="https://rpc.kichain.chaintools.tech:443"
RPC_SERVERS="https://kichain-rpc.polkachu.com:443,https://rpc-mainnet.blockchain.ki:443,https://kichain-rpc.polkachu.com:443,https://rpc-kichain-ia.cosmosia.notional.ventures:443,https://kichain-mainnet-rpc.autostake.com:443,https://kichain-rpc.lavenderfive.com:443"
SNAPSHOT_DIR="$HOME/snapshots/logs"
LOG_PATH="${SNAPSHOT_DIR}/state_sync/kid_log.txt"
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

log_this "Resetting emd"
kid tendermint unsafe-reset-all --keep-addr-book

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
