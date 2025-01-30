FROM localhost/local-base-builder:latest AS builder

WORKDIR /opt

# Build gateway
RUN git clone https://github.com/edgeandnode/gateway --branch 'main' gateway-build && \
    cd gateway-build && \
    . $HOME/.cargo/env && \
    cargo build -p graph-gateway && \
    cp target/debug/graph-gateway /opt/ && \
    cd .. && \
    rm -rf gateway

FROM localhost/local-base-runtime:latest

WORKDIR /opt

# Copy built binary
COPY --from=builder /opt/graph-gateway .

COPY ./run.sh /opt/run.sh
ENTRYPOINT ["bash", "-cl", "/opt/run.sh"]
