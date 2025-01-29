# Use Node 20 ARM64 base image
FROM --platform=linux/arm64 debian:bookworm-slim AS base

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    curl \
    git \
    jq \
    libssl-dev \
    pkg-config \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20 using n version manager
RUN curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o n && \
    bash n 20.18.1 && \
    rm n && \
    npm install -g npm@latest

# Install yarn and rust
RUN npm install --global corepack yarn && \
    curl -L https://foundry.paradigm.xyz | bash && /root/.foundry/bin/foundryup && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable --profile minimal

# Build stage
FROM base AS builder

WORKDIR /opt

# Clone contracts first to ensure correct structure
RUN git clone --depth 1 --single-branch --branch 'main' https://github.com/graphprotocol/contracts && \
    cd contracts/packages/data-edge && \
    yarn install --network-timeout 1000000

# Clone and build block-oracle
WORKDIR /opt/block-oracle
RUN git clone --depth 1 https://github.com/graphprotocol/block-oracle --branch 'main' . && \
    . ~/.bashrc && \
    cargo build -p block-oracle && \
    cp target/debug/block-oracle . && \
    rm -rf target && \
    rm -rf .git

# Set up subgraph
RUN cd packages/subgraph && \
    yarn install --network-timeout 1000000 && \
    yarn cache clean && \
    npm cache clean --force

# Copy yq from official image
FROM mikefarah/yq:latest as yq

# Final stage - minimal image
FROM debian:bookworm-slim

# Install only runtime dependencies
RUN apt-get update && \
    apt-get install -y \
    nodejs \
    curl \
    jq \
    npm \
    git \
    && rm -rf /var/lib/apt/lists/* && \
    npm install -g corepack && \
    corepack enable && \
    corepack prepare yarn@4.0.2 --activate && \
    curl -L https://foundry.paradigm.xyz | bash && \
    /root/.foundry/bin/foundryup

# Add foundry to PATH
ENV PATH="/root/.foundry/bin:${PATH}"

# Set up directory structure
WORKDIR /opt

# Copy necessary files from builder
COPY --from=builder /opt/contracts /opt/contracts
COPY --from=builder /opt/block-oracle /opt/block-oracle
COPY --from=yq /usr/bin/yq /usr/bin/yq

# Copy run script to the correct location
COPY run.sh /opt/run.sh
RUN chmod +x /opt/run.sh

# Set working directory for entrypoint
WORKDIR /opt/block-oracle

# Set default command
ENTRYPOINT ["bash", "-cl", "/opt/run.sh"]
