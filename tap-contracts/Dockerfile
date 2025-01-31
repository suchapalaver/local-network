FROM localhost/local-base-builder:latest AS builder

WORKDIR /opt

# Clone and build TAP contracts
RUN git clone https://github.com/semiotic-ai/timeline-aggregation-protocol-contracts --branch 'main' tap-contracts && \
    cd tap-contracts && \
    yarn && \
    /usr/local/bin/forge build

# Clone and build TAP subgraph
RUN git clone https://github.com/semiotic-ai/timeline-aggregation-protocol-subgraph --branch 'main' --recursive tap-subgraph && \
    cd tap-subgraph && \
    yarn

FROM localhost/local-base-runtime:latest

WORKDIR /opt

# Copy built contracts and subgraph
COPY --from=builder /opt/tap-contracts /opt/tap-contracts
COPY --from=builder /opt/tap-subgraph /opt/tap-subgraph

COPY ./run.sh /opt/run.sh
ENTRYPOINT ["bash", "-cl", "/opt/run.sh"]
