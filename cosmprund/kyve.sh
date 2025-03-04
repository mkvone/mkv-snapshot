#!/bin/bash

# Configuration variables

PARENT_DIR="/home/ubuntu/.kyve"
DATA_PATH="${PARENT_DIR}/data/"
SNAPSHOT_DIR="${DATA_PATH}snapshots"
SERVICE_NAME="kyve.service"
RPC_ADDRESS="http://localhost:10757"
CLI_COMMAND="kyved"
CATCHING_UP=$(curl -s ${RPC_ADDRESS}/status | jq -r .result.sync_info.catching_up)

LOG_PATH="/home/ubuntu/snapshots/logs/cosmprund/kyve_log.txt"
mkdir -p $(dirname ${LOG_PATH}) 

now_date() {
    echo -n $(TZ=":Europe/Moscow" date '+%Y-%m-%d_%H:%M:%S')
}

# Logging function
log_this() {
    local logging="$@"
    printf "|$(now_date)| $logging\n" | tee -a ${LOG_PATH}
}

if [[ "$CATCHING_UP" == "false" ]]; then
    log_this "Start\n---------------------------------------------------------\n"
    log_this "Node is fully synced."

    log_this "Stopping ${SERVICE_NAME}"
    sudo systemctl stop ${SERVICE_NAME}
    SERVICE_STOP_STATUS=$?
    log_this "Service stop status: $SERVICE_STOP_STATUS"

    log_this "Pruning data"
    PRUNE_OUTPUT=$(sudo docker run -v ${DATA_PATH}:${DATA_PATH} cosmprund prune ${DATA_PATH} 2>&1)
    log_this "$PRUNE_OUTPUT"
    log_this "Finish pruning"
    
    DOCKER_PRUNE_OUTPUT=$(sudo docker container prune -f 2>&1)
    log_this "Docker container prune output:"
    log_this "${DOCKER_PRUNE_OUTPUT}"
    log_this "Docker containers pruned"


    log_this "Cleaning up snapshot directories that are numerically named"
    CLEANUP_OUTPUT=$(find ${SNAPSHOT_DIR} -maxdepth 1 -type d -regex ".*/[0-9]+" -exec rm -rv {} + 2>&1)
    log_this "${CLEANUP_OUTPUT}"
    log_this "Numerical directories cleanup complete"
    sudo chown -R $(whoami):$(whoami) ${DATA_PATH}
    rm -rf ${DATA_PATH}tx_index.db

    
    sudo systemctl start ${SERVICE_NAME}
    SERVICE_START_STATUS=$?
    log_this "Service start status: $SERVICE_START_STATUS"
    
    DISK_USAGE=$(du -hs ${DATA_PATH})
    log_this "Disk usage: $DISK_USAGE"
    log_this "Done\n---------------------------------------------------------\n"
else
    log_this "Node is still catching up. Snapshot creation skipped."
fi
