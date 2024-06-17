sudo systemctl stop emoney
rm -rf ~/.emd/sentry1/data/*
SNAP_URL="https://snapshots.mkv.one/mainnet"
SNAP_NAME=$(curl -s ${SNAP_URL}/emoney/ | \
    awk -F'"' '/href=".*emoney.*\.tar\.lz4"/ {print $2}' | \
    sed 's/^\.\///' | \
    sort -t_ -k2 | \
    tail -n 1)

curl -o - -L ${SNAP_URL}/emoney/${SNAP_NAME} | lz4 -c -d - | tar -x -C $HOME/.emd/sentry1

sudo systemctl start emoney