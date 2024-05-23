sudo systemctl stop emd
rm -rf ~/.emd/data/*

SNAP_NAME=$(curl -s https://snapshots.mkv.one/emoney/ | \
    awk -F'"' '/href=".*emoney.*\.tar\.lz4"/ {print $2}' | \
    sed 's/^\.\///' | \
    sort -t_ -k2 | \
    tail -n 1)

curl -o - -L https://snapshots.mkv.one/emoney/${SNAP_NAME} | lz4 -c -d - | tar -x -C $HOME/.emd

sudo systemctl start emd