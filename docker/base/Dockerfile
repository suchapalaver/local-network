FROM debian:bookworm-slim AS rust-builder

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    apt-transport-https \
    curl \
    sudo \
    && curl -fsSL https://deb.nodesource.com/setup_23.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/* \
    && corepack enable \
    && corepack prepare yarn@4.0.2 --activate

# Install common build dependencies
RUN apt-get update && \
    apt-get install -y \
    git \
    jq \
    python3 \
    build-essential \
    pkg-config \
    libssl-dev \
    clang \
    cmake \
    libsasl2-dev \
    && rm -rf /var/lib/apt/lists/*

# Get yq from official image
FROM mikefarah/yq:latest AS yq

# Back to rust-builder with all tools
FROM rust-builder AS builder

# Copy yq from official image
COPY --from=yq /usr/bin/yq /usr/bin/yq

# Install Rust and components in a single directory
RUN mkdir -p /tmp/rust && \
    cd /tmp/rust && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable --profile minimal && \
    . $HOME/.cargo/env && \
    rustup component add rustfmt && \
    rustup component add cargo && \
    rustup component add rust-std && \
    rustup component add rustc

# Install Foundry and make it available in PATH
RUN curl -L https://foundry.paradigm.xyz | bash && \
    /root/.foundry/bin/foundryup && \
    ln -s /root/.foundry/bin/forge /usr/local/bin/forge && \
    ln -s /root/.foundry/bin/cast /usr/local/bin/cast && \
    ln -s /root/.foundry/bin/anvil /usr/local/bin/anvil

# Pre-download Solidity compiler for hardhat
RUN mkdir -p /root/.cache/hardhat-nodejs/compilers/linux-amd64 && \
    curl -L https://binaries.soliditylang.org/linux-amd64/solc-linux-amd64-v0.7.6+commit.7338295f > \
    /root/.cache/hardhat-nodejs/compilers/linux-amd64/solc-linux-amd64-v0.7.6+commit.7338295f && \
    chmod +x /root/.cache/hardhat-nodejs/compilers/linux-amd64/solc-linux-amd64-v0.7.6+commit.7338295f

FROM debian:bookworm-slim AS runtime-base
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    apt-transport-https \
    curl \
    unzip \
    git \
    jq \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/* \
    && corepack enable \
    && corepack prepare yarn@4.0.2 --activate

# Copy yq and Solidity compiler from builder
COPY --from=yq /usr/bin/yq /usr/bin/yq
COPY --from=builder /root/.cache/hardhat-nodejs/compilers /root/.cache/hardhat-nodejs/compilers
