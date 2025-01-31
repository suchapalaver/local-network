FROM localhost/local-base-builder:latest AS builder

WORKDIR /opt/build

# Build block-oracle
RUN git clone https://github.com/graphprotocol/block-oracle --branch 'main' block-oracle-build && \
    cd block-oracle-build && \
    . $HOME/.cargo/env && \
    cargo build -p block-oracle && \
    mkdir -p /opt/bin && \
    cp target/debug/block-oracle /opt/bin/

FROM localhost/local-base-runtime:latest

WORKDIR /opt/app

COPY --from=builder /opt/bin/block-oracle .

# Build subgraph and contracts with different directory names
RUN git clone https://github.com/graphprotocol/block-oracle --branch 'main' block-oracle-subgraph && \
    cd block-oracle-subgraph/packages/subgraph && \
    yarn

RUN git clone https://github.com/graphprotocol/contracts --branch 'main' contracts-data-edge && \
    cd contracts-data-edge/packages/data-edge && \
    yarn

COPY ./run.sh /opt/app/run.sh
ENTRYPOINT ["bash", "-cl", "./run.sh"]
