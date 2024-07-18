DAEMON=sentry-kava
CHAIN=kava
SNAP_PATH=$HOME/.sentry/.kava
SNAP_URL="https://snapshots.mkv.one/mainnet"


sudo systemctl stop ${DAEMON}
rm -rf $SNAP_PATH/data/*

SNAP_NAME=$(curl -s ${SNAP_URL}/${CHAIN}/ | \
    awk -F'"' '/href=".*.*\.tar\.lz4"/ {print $2}' | \
    sed 's/^\.\///' | \
    sort -t_ -k2 | \
    tail -n 1)
curl -o - -L ${SNAP_URL}/${CHAIN}/${SNAP_NAME} | lz4 -c -d - | tar -x -C $SNAP_PATH
sudo systemctl start ${DAEMON}