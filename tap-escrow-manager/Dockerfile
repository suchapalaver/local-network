FROM localhost/local-base-builder:latest AS builder

WORKDIR /opt

# Clone and build tap-escrow-manager
RUN git clone https://github.com/edgeandnode/tap-escrow-manager --branch 'main' tap-escrow-manager-build && \
    cd tap-escrow-manager-build && \
    . $HOME/.cargo/env && \
    cargo build -p tap-escrow-manager && \
    cp target/debug/tap-escrow-manager /opt/

FROM localhost/local-base-runtime:latest

WORKDIR /opt

# Install rpk
RUN curl -LO https://github.com/redpanda-data/redpanda/releases/latest/download/rpk-linux-amd64.zip && \
    unzip rpk-linux-amd64.zip -d /usr/local/bin/

# Copy the binary
COPY --from=builder /opt/tap-escrow-manager .

COPY ./run.sh /opt/run.sh
ENTRYPOINT ["bash", "-cl", "/opt/run.sh"]
