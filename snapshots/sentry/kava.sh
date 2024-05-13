sudo apt-get install wget liblz4-tool aria2 -y
sudo systemctl stop kavas 
kava tendermint unsafe-reset-all --keep-addr-book --home /home/ubuntu/.kava/sentry1
cd ~/.kava/
SNAP_NAME=$(curl -s https://snapshots.mkv.one/kava/ | \
    awk -F'"' '/href=".*kava.*\.tar\.lz4"/ {print $2}' | \
    sed 's/^\.\///' | \
    sort -t_ -k2 | \
    tail -n 1)
curl -o - -L https://snapshots.mkv.one/kava/${SNAP_NAME} | lz4 -c -d - | tar -x -C $HOME/.kava/sentry1

sudo systemctl start kavas
