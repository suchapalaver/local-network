FROM debian:bookworm-slim AS rust-builder

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates apt-transport-https && \
    rm -rf /var/lib/apt/lists/*

# Install common build dependencies
RUN apt-get update && \
    apt-get install -y \
    curl \
    git \
    jq \
    nodejs \
    npm \
    python3 \
    build-essential \
    pkg-config \
    libssl-dev \
    clang \
    cmake \
    libsasl2-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Rust in rust-builder
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable --profile minimal && \
    . $HOME/.cargo/env

# Get yq from official image
FROM mikefarah/yq:latest AS yq

# Back to rust-builder with all tools
FROM rust-builder AS builder

# Copy yq from official image
COPY --from=yq /usr/bin/yq /usr/bin/yq

# Install Node.js tools
RUN npm install --global corepack yarn && \
    corepack enable && \
    corepack install -g yarn@4.0.2

# Install Foundry
RUN curl -L https://foundry.paradigm.xyz | bash && \
    /root/.foundry/bin/foundryup

# Pre-download Solidity compiler for hardhat
RUN mkdir -p /root/.cache/hardhat-nodejs/compilers && \
    curl -L https://binaries.soliditylang.org/linux-amd64/solc-linux-amd64-v0.7.6+commit.7338295f > \
    /root/.cache/hardhat-nodejs/compilers/solc-0.7.6+commit.7338295f

FROM debian:bookworm-slim AS runtime-base
RUN apt-get update && \
    apt-get install -y \
    curl \
    git \
    jq \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/* && \
    npm install --global corepack yarn && \
    corepack enable && \
    corepack install -g yarn@4.0.2

# Copy yq and Solidity compiler from builder
COPY --from=yq /usr/bin/yq /usr/bin/yq
COPY --from=builder /root/.cache/hardhat-nodejs/compilers /root/.cache/hardhat-nodejs/compilers
