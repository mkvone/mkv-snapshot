sudo systemctl stop emd
cp $HOME/.emd/config/addrbook.json $HOME/.emd/config/addrbook.json.bak
emd unsafe-reset-all

SNAP_NAME=$(curl -s https://snapshots.mkv.one/emoney/ | \
    awk -F'"' '/href=".*emoney.*\.tar\.lz4"/ {print $2}' | \
    sed 's/^\.\///' | \
    sort -t_ -k2 | \
    tail -n 1)

curl -o - -L https://snapshots.mkv.one/emoney/${SNAP_NAME} | lz4 -c -d - | tar -x -C $HOME/.emd

cp $HOME/.emd/config/addrbook.json.bak $HOME/.emd/config/addrbook.json
sudo systemctl start emd