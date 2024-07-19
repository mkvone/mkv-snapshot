DAEMON=validator-kid
CHAIN=kichain
SNAP_PATH=$HOME/.validator/.kid
SNAP_URL="https://snapshots.mkv.one/mainnet"

SNAP_NAME=$(curl -s ${SNAP_URL}/${CHAIN}/ | \
    awk -F'"' '/href=".*.*\.tar\.lz4"/ {print $2}' | \
    sed 's/^\.\///' | \
    sort -t_ -k2 | \
    tail -n 1)

wget -O ${SNAP_PATH}/${SNAP_NAME} ${SNAP_URL}/${CHAIN}/${SNAP_NAME}
sudo systemctl stop ${DAEMON}
rm -rf $SNAP_PATH/data/*
tar -xvf ${SNAP_PATH}/${SNAP_NAME} -C $SNAP_PATH
# curl -o - -L ${SNAP_URL}/${CHAIN}/${SNAP_NAME} | lz4 -c -d - | tar -x -C $SNAP_PATH
sudo systemctl start ${DAEMON}