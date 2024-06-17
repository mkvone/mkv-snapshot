sudo systemctl stop kids
rm -rf ~/.kid/sentry1/data/*
SNAP_URL="https://snapshots.mkv.one/mainnet"
SNAP_NAME=$(curl -s ${SNAP_URL}/kichain/ | \
    awk -F'"' '/href=".*kichain.*\.tar\.lz4"/ {print $2}' | \
    sed 's/^\.\///' | \
    sort -t_ -k2 | \
    tail -n 1)
curl -o - -L ${SNAP_URL}/kichain/${SNAP_NAME} | lz4 -c -d - | tar -x -C $HOME/.kid/sentry1

sudo systemctl start kids