DAEMON=sentry-odin
CHAIN=odin
SNAP_PATH=$HOME/.sentry/.odind
SNAP_URL="https://snapshots.mkv.one/mainnet"

SNAP_NAME=$(curl -s ${SNAP_URL}/${CHAIN}/ | \
    awk -F'"' '/href=".*.*\.tar\.lz4"/ {print $2}' | \
    sed 's/^\.\///' | \
    sort -t_ -k2 | \
    tail -n 1)

wget -O ${SNAP_PATH}/${SNAP_NAME} ${SNAP_URL}/${CHAIN}/${SNAP_NAME}
sudo systemctl stop ${DAEMON}
rm -rf $SNAP_PATH/data/*
lz4 -c -d ${SNAP_PATH}/${SNAP_NAME} | tar -x -C $SNAP_PATH
rm -rf ${SNAP_PATH}/${SNAP_NAME}
sudo systemctl start ${DAEMON}