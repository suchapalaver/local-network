FROM localhost/local-base-builder:latest AS builder

WORKDIR /opt

# Copy from the official image - v0.36.0 has a janky IPFS client
# COPY --from=graphprotocol/graph-node:9fdfdca /usr/local/bin/graph-node /opt/graph-node
COPY --from=localhost/local-graph-node:latest /usr/local/bin/graph-node /opt/graph-node

FROM localhost/local-base-runtime:latest

WORKDIR /opt

COPY --from=builder /opt/graph-node /opt/graph-node

COPY ./run.sh /opt/run.sh
ENTRYPOINT ["bash", "-cl", "/opt/run.sh"]
