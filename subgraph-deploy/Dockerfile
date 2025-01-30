FROM debian:bookworm-slim

# Create non-root user
RUN useradd -m -u 1000 runner

# Install dependencies and Rust
RUN apt-get update && \
    apt-get install -y curl jq nodejs npm python3 build-essential pkg-config libssl-dev git && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    . $HOME/.cargo/env && \
    rm -rf /var/lib/apt/lists/* && \
    npm install --global yarn && \
    yarn global add @graphprotocol/indexer-cli

# Install foundry (alternative method)
RUN git clone https://github.com/foundry-rs/foundry.git && \
    cd foundry && \
    git checkout nightly && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    . $HOME/.cargo/env && \
    cargo build --release && \
    cp target/release/cast /usr/local/bin/ && \
    cd .. && \
    rm -rf foundry

# Copy and setup run script
COPY run.sh /home/runner/run.sh
RUN chmod +x /home/runner/run.sh && \
    chown -R runner:runner /home/runner

USER runner
WORKDIR /home/runner
ENTRYPOINT ["bash", "-cl", "./run.sh"]
