FROM localhost/local-base-runtime:latest

WORKDIR /opt

# Copy and set permissions on run.sh before creating user
COPY ./run.sh ./run.sh
RUN chmod +x ./run.sh

# Create non-root user
RUN useradd -m -u 1000 runner && \
    chown -R runner:runner /opt

USER runner
WORKDIR /opt

# Install graph-cli globally and ensure it's in PATH
RUN yarn global bin && \
    export PATH="$(yarn global bin):$PATH" && \
    yarn global add @graphprotocol/graph-cli && \
    echo 'export PATH="'$(yarn global bin)':$PATH"' >> ~/.bashrc

ENTRYPOINT ["bash", "-cl", "./run.sh"]
