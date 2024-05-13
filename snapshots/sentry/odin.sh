sudo systemctl stop odins
odind tendermint unsafe-reset-all --keep-addr-book --home /home/ubuntu/.odin/sentry1
SNAP_NAME=$(curl -s https://snapshots.mkv.one/odin/ | \
    awk -F'"' '/href=".*odin.*\.tar\.lz4"/ {print $2}' | \
    sed 's/^\.\///' | \
    sort -t_ -k2 | \
    tail -n 1)
curl -o - -L https://snapshots.mkv.one/odin/${SNAP_NAME} | lz4 -c -d - | tar -x -C $HOME/.odin/sentry1

sudo systemctl start odins