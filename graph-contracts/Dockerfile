FROM localhost/local-base-builder:latest AS builder

WORKDIR /opt

# Create hardhat compiler directory and set permissions
RUN mkdir -p /root/.cache/hardhat-nodejs/compilers/linux-amd64 && \
    chmod -R 777 /root/.cache

# Download compiler directly
RUN curl -L https://binaries.soliditylang.org/linux-amd64/solc-linux-amd64-v0.7.6+commit.7338295f \
    -o /root/.cache/hardhat-nodejs/compilers/linux-amd64/solc-linux-amd64-v0.7.6+commit.7338295f && \
    chmod +x /root/.cache/hardhat-nodejs/compilers/linux-amd64/solc-linux-amd64-v0.7.6+commit.7338295f

# Clone and build contracts
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
