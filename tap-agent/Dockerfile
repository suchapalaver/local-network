FROM localhost/local-base-builder:latest AS builder

WORKDIR /opt

# Copy from your local arm64-compatible image
COPY --from=localhost/local-indexer-tap-agent:latest /usr/local/bin/indexer-tap-agent /opt/tap-agent

FROM localhost/local-base-runtime:latest

WORKDIR /opt

COPY --from=builder /opt/tap-agent /opt/tap-agent

COPY ./run.sh /opt/run.sh
ENTRYPOINT ["bash", "-cl", "/opt/run.sh"]