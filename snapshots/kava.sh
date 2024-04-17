sudo apt-get install wget liblz4-tool aria2 -y
sudo systemctl stop kava 
kava tendermint unsafe-reset-all --keep-addr-book
cd ~/.kava/
SNAP_NAME=$(curl -s https://snapshots.mkv.one/kava/ | awk -F'"' '/href=".*kava_.*\.tar\.lz4"/ {print $2}' | sed 's/^\.\///')

# curl -o - -L https://snapshots.mkv.one/kava/${SNAP_NAME} | lz4 -c -d - | tar -x -C $HOME/.kava
aria2c -x5 -s5 -o ${SNAP_NAME} https://snapshots.mkv.one/kava/${SNAP_NAME}
lz4 -c -d ${SNAP_NAME} | tar -x -C $HOME/.kava
sudo systemctl start kava
