# Build stage
FROM debian:bookworm-slim AS builder

# Create non-root user
RUN useradd -m -u 1000 builder

# Install system dependencies
RUN apt-get update && \
    apt-get install -y curl git jq nodejs npm wget python3 build-essential && \
    rm -rf /var/lib/apt/lists/* && \
    npm install --global yarn

# Switch to non-root user
USER builder

# Install foundry
RUN curl -L https://foundry.paradigm.xyz | bash && \
    /home/builder/.foundry/bin/foundryup

WORKDIR /home/builder

# Pre-download Solidity compiler
RUN mkdir -p .cache/hardhat-nodejs/compilers && \
    wget -O .cache/hardhat-nodejs/compilers/solc-0.7.6+commit.7338295f.js \
    https://binaries.soliditylang.org/bin/soljson-v0.7.6+commit.7338295f.js || \
    curl -Lo .cache/hardhat-nodejs/compilers/solc-0.7.6+commit.7338295f.js \
    https://binaries.soliditylang.org/bin/soljson-v0.7.6+commit.7338295f.js

# Clone and build TAP contracts
RUN git clone https://github.com/semiotic-ai/timeline-aggregation-protocol-contracts --branch 'main' && \
    cd timeline-aggregation-protocol-contracts && \
    yarn --network-timeout 100000 && \
    /home/builder/.foundry/bin/forge build

# Clone and build TAP subgraph
RUN git clone https://github.com/semiotic-ai/timeline-aggregation-protocol-subgraph --branch 'main' --recursive && \
    cd timeline-aggregation-protocol-subgraph && \
    yarn --network-timeout 100000

# Get yq for the runtime stage
FROM mikefarah/yq:latest AS yq

# Runtime stage
FROM debian:bookworm-slim

# Create non-root user
RUN useradd -m -u 1000 runner

# Install runtime dependencies
RUN apt-get update && \
    apt-get install -y nodejs npm && \
    npm install --global yarn && \
    rm -rf /var/lib/apt/lists/*

# Copy foundry from builder
COPY --from=builder /home/builder/.foundry/bin/forge /usr/local/bin/forge
COPY --from=builder /home/builder/.foundry/bin/cast /usr/local/bin/cast

# Copy built contracts and subgraph
COPY --from=builder /home/builder/timeline-aggregation-protocol-contracts /home/runner/timeline-aggregation-protocol-contracts
COPY --from=builder /home/builder/timeline-aggregation-protocol-subgraph /home/runner/timeline-aggregation-protocol-subgraph

# Copy compiler cache
COPY --from=builder /home/builder/.cache/hardhat-nodejs/compilers /home/runner/.cache/hardhat-nodejs/compilers

# Copy yq from yq stage
COPY --from=yq /usr/bin/yq /usr/bin/yq

# Copy and setup run script
COPY run.sh /home/runner/run.sh
RUN chmod +x /home/runner/run.sh && \
    chown -R runner:runner /home/runner

USER runner
WORKDIR /home/runner
ENTRYPOINT ["bash", "-cl", "./run.sh"]
