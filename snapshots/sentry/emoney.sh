sudo systemctl stop emoney
cp $HOME/.emd/sentry1/config/addrbook.json $HOME/.emd/sentry1/config/addrbook.json.bak
emd unsafe-reset-all --home /home/ubuntu/.emd/sentry1

SNAP_NAME=$(curl -s https://snapshots.mkv.one/emoney/ | \
    awk -F'"' '/href=".*emoney.*\.tar\.lz4"/ {print $2}' | \
    sed 's/^\.\///' | \
    sort -t_ -k2 | \
    tail -n 1)

curl -o - -L https://snapshots.mkv.one/emoney/${SNAP_NAME} | lz4 -c -d - | tar -x -C $HOME/.emd/sentry1

cp $HOME/.emd/sentry1/config/addrbook.json.bak $HOME/.emd/sentry1/config/addrbook.json
sudo systemctl start emoney