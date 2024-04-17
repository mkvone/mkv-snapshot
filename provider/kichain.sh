#!/bin/bash

# Configuration variables
SNAP_PATH="/home/ubuntu/snapshots/kichain"
LOG_PATH="/home/ubuntu/snapshots/logs/kichain_log.txt"
DATA_PATH="/home/ubuntu/.kid/data/"
SERVICE_NAME="kid.service"
RPC_ADDRESS="http://localhost:36637"

# Function to get current time in a specific format
now_date() {
    echo -n $(TZ=":Europe/Moscow" date '+%Y-%m-%d_%H:%M:%S')
}

# Logging function
log_this() {
    local logging="$@"
    printf "|$(now_date)| $logging\n" | tee -a ${LOG_PATH}
}

# Check if the node is fully synced
CATCHING_UP=$(curl -s ${RPC_ADDRESS}/status | jq -r .result.sync_info.catching_up)
CHAIN_ID=$(curl -s ${RPC_ADDRESS}/status | jq -r .result.node_info.network)
SNAP_NAME=$(echo "${CHAIN_ID}_$(date '+%Y%m%d_%H%M').tar")
OLD_SNAP=$(ls ${SNAP_PATH} | egrep -o "${CHAIN_ID}.*tar.lz4")
if [[ "$CATCHING_UP" == "false" ]]; then
    log_this "Node is fully synced."

    log_this "Stopping ${SERVICE_NAME}"
    sudo systemctl stop ${SERVICE_NAME}
    echo $? >> ${LOG_PATH}

    log_this "Creating new snapshot"
    tar cf ${HOME}/${SNAP_NAME} -C ${DATA_PATH} data
    lz4 ${HOME}/${SNAP_NAME} ${HOME}/${SNAP_NAME}.lz4
    rm ${HOME}/${SNAP_NAME}  # Clean up the uncompressed tar file
    log_this "Snapshot compressed with lz4."

    log_this "Starting ${SERVICE_NAME}"
    sudo systemctl start ${SERVICE_NAME}
    echo $? >> ${LOG_PATH}

    log_this "Removing old snapshot(s):"
    cd ${SNAP_PATH}
    rm -fv ${OLD_SNAP} &>>${LOG_PATH}

    log_this "Moving new snapshot to ${SNAP_PATH}"
    mv ${HOME}/${SNAP_NAME}.lz4 ${SNAP_PATH} &>>${LOG_PATH}

    du -hs ${SNAP_PATH} | tee -a ${LOG_PATH}
    log_this "Done\n---------------------------\n"
else
    log_this "Node is still catching up. Snapshot creation skipped."
fi