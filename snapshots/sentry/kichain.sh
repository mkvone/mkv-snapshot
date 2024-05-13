sudo systemctl stop kids
kid tendermint unsafe-reset-all --keep-addr-book --home /home/ubuntu/.kid/sentry1

SNAP_NAME=$(curl -s https://snapshots.mkv.one/kichain/ | \
    awk -F'"' '/href=".*kichain.*\.tar\.lz4"/ {print $2}' | \
    sed 's/^\.\///' | \
    sort -t_ -k2 | \
    tail -n 1)
curl -o - -L https://snapshots.mkv.one/kichain/${SNAP_NAME} | lz4 -c -d - | tar -x -C $HOME/.kid/sentry1

sudo systemctl start kids