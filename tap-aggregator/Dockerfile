FROM localhost/local-base-builder:latest AS builder

WORKDIR /opt

# Copy from your local arm64-compatible image with correct name
COPY --from=localhost/local-tap-aggregator:latest /usr/local/bin/tap_aggregator /opt/tap_aggregator

FROM localhost/local-base-runtime:latest

WORKDIR /opt

# Copy the binary
COPY --from=builder /opt/tap_aggregator .

COPY ./run.sh /opt/run.sh
ENTRYPOINT ["bash", "-cl", "/opt/run.sh"]