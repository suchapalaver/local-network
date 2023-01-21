#!/bin/sh
. ./prelude.sh

github_clone edgeandnode/graph-gateway

cd build/edgeandnode/graph-gateway
cargo build
cd -

await_ready graph-subgraph
await "test -f build/studio-admin-auth.txt"

export STUDIO_AUTH=$(cat build/studio-admin-auth.txt)

cd build/edgeandnode/graph-gateway

export RUST_LOG=info,graph_gateway=trace
export LOG_JSON=false
export MNEMONIC="${MNEMONIC}"
export ETHEREUM_PROVIDERS="${ETHEREUM_NETWORK}=3,http://localhost:${ETHEREUM_PORT}"
export NETWORK_SUBGRAPH="http://localhost:${GRAPH_NODE_GRAPHQL_PORT}/subgraphs/id/${NETWORK_SUBGRAPH_DEPLOYMENT}"
export IPFS="http://localhost:${IPFS_PORT}/api/v0/cat?arg="
# export RESTRICTED_NETWORKS="hardhat=${NETWORK_SUBGRAPH_DEPLOYMENT}"
# export RESTRICTED_DEPLOYMENTS="${NETWORK_SUBGRAPH_DEPLOYMENT}=${ACCOUNT_ADDRESS}"

export STUDIO_URL="http://localhost:${STUDIO_ADMIN_PORT}/admin/v1"
export API_KEY_PAYMENT_REQUIRED=true

export PORT="${GATEWAY_PORT}"
export METRICS_PORT="${GATEWAY_METRICS_PORT}"

export REDPANDA_BROKERS="localhost:${REDPANDA_PORT}"
export FISHERMAN="http://localhost:${FISHERMAN_PORT}"

export LOCATION_COUNT=1
export REPLICA_COUNT=1

cargo run --bin graph-gateway
