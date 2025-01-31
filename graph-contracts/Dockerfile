FROM localhost/local-base-builder:latest AS builder

WORKDIR /opt

RUN mkdir -p /root/.cache/hardhat-nodejs/compilers/linux-amd64 && \
    chmod -R 777 /root/.cache

RUN curl -L https://binaries.soliditylang.org/linux-amd64/solc-linux-amd64-v0.7.6+commit.7338295f \
    -o /root/.cache/hardhat-nodejs/compilers/linux-amd64/solc-linux-amd64-v0.7.6+commit.7338295f && \
    chmod +x /root/.cache/hardhat-nodejs/compilers/linux-amd64/solc-linux-amd64-v0.7.6+commit.7338295f

RUN git clone https://github.com/graphprotocol/contracts --branch '@graphprotocol/contracts@6.2.1' contracts-build && \
    cd contracts-build && \
    cd packages/contracts && \
    yarn && \
    yarn compile

RUN git clone https://github.com/graphprotocol/graph-network-subgraph --branch 'v1.1.0' && \
    cd graph-network-subgraph && \
    yarn

COPY ./run.sh /opt/run.sh
ENTRYPOINT ["bash", "-cl", "/opt/run.sh"]
