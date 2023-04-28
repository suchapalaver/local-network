#!/bin/sh
. ./prelude.sh

github_clone edgeandnode/graph-gateway

cd build/edgeandnode/graph-gateway
cargo build
cd -

await_ready graph-subgraph
await_ready subscriptions
await "test -f build/studio-admin-auth.txt"

export STUDIO_AUTH=$(cat build/studio-admin-auth.txt)
export SUBSCRIPTIONS_CONTRACT=$(jq -r '.contract' build/subscriptions.json)
export SUBSCRIPTIONS_DEPLOYMENT=$(jq -r '.deployment' build/subscriptions.json)
envsubst <gateway.jsonnet >build/gateway.jsonnet
jsonnet build/gateway.jsonnet >build/gateway.json

cd build/edgeandnode/graph-gateway

export RUST_LOG=info,graph_gateway=trace
cargo watch -x 'run --bin graph-gateway ../../gateway.json'
