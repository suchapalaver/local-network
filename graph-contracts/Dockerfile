FROM localhost/local-base-builder:latest AS builder

WORKDIR /opt

RUN git clone https://github.com/graphprotocol/contracts --branch '@graphprotocol/contracts@6.2.1' contracts-build && \
    cd contracts-build/packages/contracts && \
    yarn && \
    yarn compile && \
    ls -la build

FROM localhost/local-base-runtime:latest

WORKDIR /opt

COPY --from=builder /opt/contracts-build/packages/contracts/build /opt/contracts/build

RUN git clone https://github.com/graphprotocol/graph-network-subgraph --branch 'v1.1.0' && \
    cd graph-network-subgraph && \
    yarn

COPY ./run.sh /opt/run.sh
ENTRYPOINT ["bash", "-cl", "/opt/run.sh"]
