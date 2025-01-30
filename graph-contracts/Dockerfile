# Build stage
FROM debian:bookworm-slim AS builder

# Install system dependencies
RUN apt-get update && \
    apt-get install -y curl git jq nodejs npm && \
    rm -rf /var/lib/apt/lists/* && \
    npm install --global corepack yarn && \
    corepack enable && corepack install -g yarn@4.0.2

WORKDIR /opt
# Clone and build Graph contracts
RUN git clone https://github.com/graphprotocol/contracts --branch '@graphprotocol/contracts@6.2.1' && \
    cd contracts/packages/contracts && yarn && yarn compile

# Clone and build Graph network subgraph
RUN git clone https://github.com/graphprotocol/graph-network-subgraph --branch 'v1.1.0' && \
    cd graph-network-subgraph && yarn

# Runtime stage
FROM debian:bookworm-slim

# Install runtime dependencies
RUN apt-get update && \
    apt-get install -y nodejs npm curl jq && \
    npm install --global corepack yarn && \
    corepack enable && corepack install -g yarn@4.0.2 && \
    rm -rf /var/lib/apt/lists/*

# Copy built contracts and subgraph
COPY --from=builder /opt/contracts /opt/contracts
COPY --from=builder /opt/graph-network-subgraph /opt/graph-network-subgraph

# Copy and setup run script
COPY run.sh /opt/run.sh
RUN chmod +x /opt/run.sh

WORKDIR /opt
ENTRYPOINT ["bash", "-cl", "/opt/run.sh"]
