#!/bin/bash

# If SNAP_RPC does not work, use altanative address
sudo systemctl stop emd
cp $HOME/.emd/config/addrbook.json $HOME/.emd/config/addrbook.json.bak
emd unsafe-reset-all
RPC_SERVERS="https://rpc-emoney.keplr.app:443,https://emoney.validator.network:443,https://rpc.emoney.badgerbite.xyz:443,https://rpc-emoney-ia.cosmosia.notional.ventures:443,https://rpc.emoney.freak12techno.io:443,https://e-money-rpc.ibs.team:443,https://rpc-emoney.goldenratiostaking.net:443,https://rpc.emoney.bh.rocks:443"

SNAP_RPC="https://emoney.validator.network:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 500)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$RPC_SERVERS,$RPC_SERVERS\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.emd/config/config.toml

cp $HOME/.emd/config/addrbook.json.bak $HOME/.emd/config/addrbook.json
sudo systemctl start emd