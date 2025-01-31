# Use our local ARM-compatible graph-node image
FROM localhost/local-graph-node:latest

# Install additional dependencies
RUN apt-get update && apt-get install -y \
  curl \
  && rm -rf /var/lib/apt/lists/*

# Ensure /usr/local/bin is in PATH
ENV PATH="/usr/local/bin:${PATH}"

COPY ./run.sh /opt/run.sh
RUN chmod +x /opt/run.sh

# Debug: verify our environment
RUN which graph-node && \
    echo "PATH=$PATH" && \
    ls -l /usr/local/bin/graph-node

ENTRYPOINT ["bash", "-cl", "/opt/run.sh"]
