sudo systemctl stop odin
odind tendermint unsafe-reset-all --keep-addr-book
SNAP_NAME=$(curl -s https://snapshots.mkv.one/odin/ | awk -F'"' '/href=".*odin.*\.tar\.lz4"/ {print $2}' | sed 's/^\.\///')

curl -o - -L https://snapshots.mkv.one/odin/${SNAP_NAME} | lz4 -c -d - | tar -x -C $HOME/.odin

sudo systemctl start odin