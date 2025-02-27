# local-network ARM64

We all know Macs are abominations and we'd all rather work on Linux laptops.

That said ...

Use locally built images where necessary for:

- `graph-node`
- `indexer-agent`
- `indexer-service`
- `indexer-tap-agent`
- `tap-aggregator`

For example, to build `indexer-tap-agent`, run the following from the root of the `indexer-rs` repo:

```bash
docker build -t local-indexer-tap-agent:latest -f Dockerfile.indexer-tap-agent .
```

To run `docker compose up` first `docker compose build` the `base-builder` and `base-runtime` images:

```bash
docker compose build base-builder base-runtime
```

## This fork useful commands:

```terminal
docker compose down --remove-orphans -v
```

## local-network upstream docs

a local Graph network for debugging & integration tests

## setup

1. install Docker & Docker Compose
2. `docker compose down && docker compose up --build`

## useful commands

- `docker compose up --build -d ${service}`
- `docker logs -f ${service}`
- `docker system prune`
- `source .env`

## chain

- Foundry docs: https://book.getfoundry.sh/

## ipfs

- cat file via curl:
  
```bash
curl -X POST "http://localhost:5001/api/v0/cat?arg=f1220d6b169dcf83bfe0f615baa2d83e9adf77d520b52faf18a759eb7277b6d66fa7f"
```

- cat file via CLI:

```bash
ipfs --api=/ip4/127.0.0.1/tcp/5001 cat QmagRyTMp4qcRb8fJufk7urNwCQmmUEB9mC6nxHQuKwydb
```

- note: if you have a hex digest, a valid CID for it is the hex digits prefixed by `f1220`. For example, `0xd6b169dcf83bfe0f615baa2d83e9adf77d520b52faf18a759eb7277b6d66fa7f` -> `f1220d6b169dcf83bfe0f615baa2d83e9adf77d520b52faf18a759eb7277b6d66fa7f`

## postgres

- `psql -h localhost -U postgres`

## graph-node

- GraphiQL interface: http://localhost:8000/subgraphs/name/${subgraph_name}/graphql

## graph-contracts

- subgraph: http://localhost:8000/subgraphs/name/graph-network

```graphql
  {
    indexers {
      id
      url
    }
    subgraphs {
      id
      versions {
        subgraphDeployment {
          ipfsHash
          indexerAllocations {
            id
            status
            indexer {
              id
            }
          }
        }
      }
    }
    _meta {
      block {
        number
      }
      deployment
    }
  }
```

## block-oracle

- subgraph: http://localhost:8000/subgraphs/name/block-oracle

```graphql
  {
    networks {
      id
    }
    _meta {
      block {
        number
      }
      deployment
    }
  }
```

## indexer-agent

- `graph indexer connect http://localhost:7600`
- `graph indexer --network=hardhat status`

## gateway

```bash
curl "http://localhost:7700/api/subgraphs/id/BFr2mx7FgkJ36Y6pE5BiXs1KmNUmVDCnL82KUSdcLW1g" \
  -H 'content-type: application/json' -H "Authorization: Bearer deadbeefdeadbeefdeadbeefdeadbeef" \
  -d '{"query": "{ _meta { block { number } } }"}'
```

## redpanda

```bash
docker exec -it redpanda rpk topic consume gateway_client_query_results --brokers="localhost:9092"
```

## tap-contracts

- subgraph: http://localhost:8000/subgraphs/name/semiotic/tap

```graphql
  {
    escrowAccounts {
      balance
      sender {
        id
      }
      receiver {
        id
      }
    }
    _meta {
      block {
        number
      }
      deployment
    }
  }
```
