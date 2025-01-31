FROM localhost/local-base-builder:latest AS builder

WORKDIR /opt

# Copy from your local arm64-compatible image
COPY --from=localhost/local-indexer-service:latest /usr/local/bin/indexer-service-rs /opt/indexer-service

FROM localhost/local-base-runtime:latest

WORKDIR /opt

COPY --from=builder /opt/indexer-service /opt/indexer-service

COPY ./run.sh /opt/run.sh
ENTRYPOINT ["bash", "-cl", "/opt/run.sh"]