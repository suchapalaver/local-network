FROM localhost/local-base-builder:latest AS builder

WORKDIR /opt

# Copy from your local arm64-compatible image
COPY --from=localhost/local-indexer-agent:latest /opt/indexer /opt/indexer

FROM localhost/local-base-runtime:latest

WORKDIR /opt

COPY --from=builder /opt/indexer /opt/indexer

COPY ./run.sh /opt/run.sh
ENTRYPOINT ["bash", "-cl", "/opt/run.sh"]
