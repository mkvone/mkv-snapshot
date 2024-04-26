# MKV.one Snapshot Management Documentation

This documentation provides an overview of the repositories involved in the snapshot creation and management processes utilized by MKV.one. These tools are essential for maintaining efficient, scalable blockchain operations, particularly for tasks like pruning blockchains, managing state synchronization, and distributing snapshots.

## Repositories Overview

### `/provider`

The `/provider` repository focuses on the broader aspects of snapshot provisioning and distribution. This includes tools and scripts necessary for creating snapshots of blockchain data, which are essential for initializing new nodes efficiently.

### `/cosmprund`

Located in the `/cosmprund` repository, this module is dedicated to the pruning of blockchain data. Pruning helps in reducing the size of the blockchain database by removing older data that is no longer necessary for the current state of the blockchain, thereby optimizing storage and performance.

### `/snapshots`

The `/snapshots` repository automatically handles the downloading of blockchain snapshots. This is particularly useful for operators or services that need to quickly sync new nodes to the current state of the blockchain without processing all historical data from genesis.

### `/state_sync`

The `/state_sync` repository contains tools and scripts that assist in the state synchronization process. State sync is a method used by blockchain nodes to rapidly synchronize to the latest state of the blockchain by fetching data snapshots from other peers instead of replaying all historical transactions.
