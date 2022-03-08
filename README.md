# Local Network Testing

## Prerequisites

- [Rust toolchain](https://rustup.rs/)
- [Overmind](https://github.com/DarthSim/overmind)
- Login to NPM (run `npm login`)
- `ts-node`, `yarn`, `yalc`, `prettier`, `eslint`, `pino-pretty`
- [Docker](https://www.docker.com/get-started)
  - Make sure the daemon is running
- libpq
  - MacOS: `brew install postgresql`
- [go-ipfs](https://github.com/ipfs/go-ipfs)
  - After installing, run `ipfs init`
  - On Linux, increase buffer size for go-ipfs QUIC transfers: `sysctl -w net.core.rmem_max=2500000`. See https://github.com/lucas-clemente/quic-go/wiki/UDP-Receive-Buffer-Size

## Initial setup

1. Clone repos: `bash clone-repos.bash`
2. Patch: `bash patch.bash`

## Build

- Clean all build files: `make clean`
- Build all: `make -j`

## Run

`overmind s`

## Useful commands

- Get API keys:

  ```bash
  psql -h localhost -U postgres -d local_network_subgraph_studio -c 'SELECT * FROM "ApiKeys";'
  ```

- Query indexer status:

  ```bash
  curl localhost:6700/api/${API_KEY}/deployments/id/QmVSnGK2tmBczx7MqnxdSAKhatpGUvpzHTsg8WE58Wakd7 \
    -H 'Content-Type: application/json' \
    -d '{"query": "{ _meta { block { number } } }"}'
  ```

- Query using subgraph name:

  ```bash
  curl localhost:6700/api/${API_KEY}/subgraphs/id/ACDJUXGoFN68GiZxeeAbqqxLoQe2dstdJawR4BMgZgVR \
    -H 'Content-Type: application/json' \
    -d '{"query": "{ _meta { block { number } } }"}'
  ```

- Query indexer directly:

  ```bash
  curl localhost:8000/subgraphs/id/QmVSnGK2tmBczx7MqnxdSAKhatpGUvpzHTsg8WE58Wakd7 \
    -H 'Content-Type: application/json' \
    -d '{"query": "{ allocations { id } }"}'
  ```

- Load env file in Bash:

  ```bash
  set -o allexport; source .overmind.env; set +o allexport
  ```

- Run gateway comparison benchmark

  ```bash
  cd bench && yarn
  # Benchmark TypeScript gateway
  ts-node bench.ts \
    gateway-ts \
    "http://${HOST}:${PORT}/api/${API_KEY}/deployments/id/QmVSnGK2tmBczx7MqnxdSAKhatpGUvpzHTsg8WE58Wakd7" \
    2>&1| tee bench-ts.csv
  # Benchmark Rust gateway
  ts-node bench.ts \
    gateway-rs \
    "http://${HOST}:${PORT}/api/${API_KEY}/deployments/id/QmVSnGK2tmBczx7MqnxdSAKhatpGUvpzHTsg8WE58Wakd7" \
    2>&1| tee bench-rs.csv
  # Show plots
  python plot.py bench-{ts,rs}.csv
  ```

- Connect indexer CLI

  ```bash
  ./projects/graphprotocol/indexer/packages/indexer-cli/bin/graph-indexer indexer connect http://localhost:18000
  ```

- Consume Kafka topics

  ```bash
  docker exec -it redpanda-1 rpk topic consume gateway_client_query_results --brokers="${REDPANDA_BROKERS}"
  ```

- Add API key indexer preferences

  `psql -h localhost -U postgres -d local_network_subgraph_studio`

  ```bash
  INSERT INTO "IndexerPreferences" (name, description, "order") VALUES ('Fastest speed', 'Time between the query and the response from an indexer. If you mark this as important we will optimize for fast indexers.', 1);
  INSERT INTO "IndexerPreferences" (name, description, "order") VALUES ('Lowest price', 'The amount paid per query. If you mark this as important we will optimize for the less expensive indexers.', 2);
  INSERT INTO "IndexerPreferences" (name, description, "order") VALUES ('Data freshness', 'How recent the latest block an indexer has processed for the subgraph you are querying. If you mark this as important we will optimize to find the indexers with the freshest data.', 3);
  INSERT INTO "IndexerPreferences" (name, description, "order") VALUES ('Economic security', 'The amount of GRT an indexer can lose if they respond incorrectly to your query. If you mark this as important we will optimize for indexers with a large stake.', 4);

  INSERT INTO "ApiKeyIndexerPreferences" ("apiKeyId", "indexerPreferenceId", "points", "weight")
  SELECT 1, id, 0, 0.00 FROM "IndexerPreferences";
  ```
