#!/bin/bash

# Configuration variables
EMD_HOME="$HOME/.emd"
CONFIG_PATH="${EMD_HOME}/config"
ADDRBOOK_JSON="${CONFIG_PATH}/addrbook.json"
SERVICE_NAME="emd.service"
RPC_ADDRESS="https://emoney.validator.network:443"
RPC_SERVERS="https://rpc-emoney.keplr.app:443,https://emoney.validator.network:443,https://rpc.emoney.badgerbite.xyz:443,https://rpc-emoney-ia.cosmosia.notional.ventures:443,https://rpc.emoney.freak12techno.io:443,https://e-money-rpc.ibs.team:443,https://rpc-emoney.goldenratiostaking.net:443,https://rpc.emoney.bh.rocks:443"
SNAPSHOT_DIR="$HOME/snapshots/logs"
LOG_PATH="${SNAPSHOT_DIR}/state_sync/emd_log.txt"
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

log_this "Backing up address book"
cp ${ADDRBOOK_JSON} ${ADDRBOOK_JSON}.bak

log_this "Resetting emd"
emd unsafe-reset-all

LATEST_HEIGHT=$(curl -s $RPC_ADDRESS/block | jq -r .result.block.header.height)
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000))
TRUST_HASH=$(curl -s "$RPC_ADDRESS/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$RPC_SERVERS,$RPC_SERVERS\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" ${CONFIG_PATH}/config.toml

log_this "Restoring address book"
cp ${ADDRBOOK_JSON}.bak ${ADDRBOOK_JSON}

log_this "Starting ${SERVICE_NAME}"
sudo systemctl start ${SERVICE_NAME}
SERVICE_START_STATUS=$?
log_this "Service start status: $SERVICE_START_STATUS"

log_this "Done\n---------------------------------------------------------\n"
