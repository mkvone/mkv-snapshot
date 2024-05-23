sudo systemctl stop kid
rm -rf ~/.kid/data/*
SNAP_NAME=$(curl -s https://snapshots.mkv.one/kichain/ | \
    awk -F'"' '/href=".*kichain.*\.tar\.lz4"/ {print $2}' | \
    sed 's/^\.\///' | \
    sort -t_ -k2 | \
    tail -n 1)
curl -o - -L https://snapshots.mkv.one/kichain/${SNAP_NAME} | lz4 -c -d - | tar -x -C $HOME/.kid

sudo systemctl start kid