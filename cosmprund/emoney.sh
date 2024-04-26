#!/bin/bash

# Configuration variables
DATA_PATH="/home/ubuntu/.emd/data/"
PARENT_DIR="/home/ubuntu/.emd"
DATA_DIR_NAME="data"
SERVICE_NAME="emd.service"
RPC_ADDRESS="http://localhost:36647"
CLI_COMMAND="emd"
CATCHING_UP=$(curl -s ${RPC_ADDRESS}/status | jq -r .result.sync_info.catching_up)

LOG_PATH="/home/ubuntu/snapshots/logs/cosmprund/emoney_log.txt"
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
    log_this "Node is fully synced."

    log_this "Stopping ${SERVICE_NAME}"
    sudo systemctl stop ${SERVICE_NAME}
    echo $? >> ${LOG_PATH}

    log_this "Pruning data"
    sudo docker run -v ${DATA_PATH}:${DATA_PATH} cosmprund prune ${DATA_PATH}
    log_this "Finish pruning"

    log_this "Starting ${SERVICE_NAME}"
    sudo systemctl start ${SERVICE_NAME}
    echo $? >> ${LOG_PATH}
    du -hs ${DATA_PATH} | tee -a ${LOG_PATH}
    log_this "Done\n---------------------------\n"
else
    log_this "Node is still catching up. Snapshot creation skipped."
fi