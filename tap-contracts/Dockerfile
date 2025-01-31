FROM localhost/local-base-builder:latest AS builder

WORKDIR /opt

# Ensure compiler directory exists and has correct permissions
RUN mkdir -p /root/.cache/hardhat-nodejs/compilers/linux-amd64
COPY --from=ethereum/solc:0.7.6 /usr/bin/solc /root/.cache/hardhat-nodejs/compilers/linux-amd64/solc-linux-amd64-v0.7.6+commit.7338295f
RUN chmod -R 777 /root/.cache

# Clone and build TAP contracts using forge
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

COPY --from=builder /opt/tap-contracts /opt/tap-contracts
COPY --from=builder /opt/tap-subgraph /opt/tap-subgraph

COPY ./run.sh /opt/run.sh
ENTRYPOINT ["bash", "-cl", "/opt/run.sh"]
