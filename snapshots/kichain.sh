sudo systemctl stop kid
kid tendermint unsafe-reset-all --keep-addr-book

SNAP_NAME=$(curl -s https://snapshots.mkv.one/kichain/ | awk -F'"' '/href=".*kichain.*\.tar\.lz4"/ {print $2}' | sed 's/^\.\///')

curl -o - -L https://snapshots.mkv.one/kichain/${SNAP_NAME} | lz4 -c -d - | tar -x -C $HOME/.kid

sudo systemctl start kid