#!/bin/bash

# Configuration variables
SNAP_PATH="/home/ubuntu/snapshots/emoney"
LOG_PATH="/home/ubuntu/snapshots/logs/emoney_log.txt"
DATA_PATH="/home/ubuntu/.emd/data/"
PARENT_DIR="/home/ubuntu/.emd"
DATA_DIR_NAME="data"
SERVICE_NAME="emd.service"
RPC_ADDRESS="http://localhost:36647"
CATCHING_UP=$(curl -s ${RPC_ADDRESS}/status | jq -r .result.sync_info.catching_up)
HEIGHT=$(curl -s ${RPC_ADDRESS}/status | jq -r .result.sync_info.latest_block_height)
CHAIN_ID=$(curl -s ${RPC_ADDRESS}/status | jq -r .result.node_info.network)
SNAP_NAME="${CHAIN_ID}_$(date '+%Y%m%d_%H%M')_${HEIGHT}.tar"
OLD_SNAP=$(ls ${SNAP_PATH} | egrep -o "${CHAIN_ID}.*tar.lz4" || echo "")
# Ensure necessary directories exist
mkdir -p ${SNAP_PATH}
mkdir -p $(dirname ${LOG_PATH})  # Creates the log directory if it doesn't exist

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


if [[ "$CATCHING_UP" == "false" ]]; then
    log_this "Node is fully synced."

    log_this "Stopping ${SERVICE_NAME}"
    sudo systemctl stop ${SERVICE_NAME}
    echo $? >> ${LOG_PATH}

    log_this "Creating new snapshot"
    tar -cf ${HOME}/${SNAP_NAME} -C ${PARENT_DIR} ${DATA_DIR_NAME}
    lz4 ${HOME}/${SNAP_NAME} ${HOME}/${SNAP_NAME}.lz4
    rm ${HOME}/${SNAP_NAME}  # Clean up the uncompressed tar file
    log_this "Snapshot compressed with lz4."

    log_this "Starting ${SERVICE_NAME}"
    sudo systemctl start ${SERVICE_NAME}
    echo $? >> ${LOG_PATH}

    log_this "Moving new snapshot to ${SNAP_PATH}"
    mv ${HOME}/${SNAP_NAME}.lz4 ${SNAP_PATH} &>> ${LOG_PATH}
    if [ $? -eq 0 ]; then
        log_this "New snapshot successfully moved."
        # Remove all snapshots except the latest two
        if [ -n "${OLD_SNAP}" ]; then
            log_this "Cleaning up old snapshots, keeping the latest two:"
            cd ${SNAP_PATH}
            # List all snapshot files, sort them by modification time, skip the last two files, and remove the rest
            ls -t ${SNAP_PATH}/${CHAIN_ID}*.tar.lz4 | tail -n +3 | xargs -I {} rm -fv {} &>> ${LOG_PATH}
        fi
    else
        log_this "Failed to move new snapshot."
    fi

    du -hs ${SNAP_PATH} | tee -a ${LOG_PATH}
    log_this "Done\n---------------------------\n"
else
    log_this "Node is still catching up. Snapshot creation skipped."
fi
