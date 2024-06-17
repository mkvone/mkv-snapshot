sudo apt-get install wget liblz4-tool aria2 -y
sudo systemctl stop kavas 
rm -rf ~/.kava/sentry1/data/*
cd ~/.kava/
SNAP_URL="https://snapshots.mkv.one/mainnet"
SNAP_NAME=$(curl -s ${SNAP_URL}/kava/ | \
    awk -F'"' '/href=".*kava.*\.tar\.lz4"/ {print $2}' | \
    sed 's/^\.\///' | \
    sort -t_ -k2 | \
    tail -n 1)
curl -o - -L ${SNAP_URL}/kava/${SNAP_NAME} | lz4 -c -d - | tar -x -C $HOME/.kava/sentry1

sudo systemctl start kavas
