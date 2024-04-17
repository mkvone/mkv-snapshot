#!/bin/bash

# If SNAP_RPC does not work, use altanative address
sudo systemctl stop kid
cp $HOME/.kid/config/addrbook.json $HOME/.kid/config/addrbook.json.bak
kid tendermint unsafe-reset-all --keep-addr-book
SNAP_RPC="https://rpc.kichain.chaintools.tech:443"
SNAP_RPC2="https://kichain-rpc.polkachu.com:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 500)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC2\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.kid/config/config.toml

cp $HOME/.kid/config/addrbook.json.bak $HOME/.kid/config/addrbook.json
sudo systemctl start kid