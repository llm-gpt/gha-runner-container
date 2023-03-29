# Use Red Hat Universal Base Image (UBI) 8-minimal
FROM redhat/ubi9-minimal

# Install required packages
RUN microdnf install -y curl tar gzip jq shadow-utils yum

# Set working directory
WORKDIR /actions-runner

# Get latest version of actions-runner
RUN LATEST_VERSION=$(curl --silent https://api.github.com/repos/actions/runner/releases/latest | jq -r '.tag_name') \
    && ARCH=$(uname -m) \
    && if [ "${ARCH}" = "x86_64" ]; then \
        URL="https://github.com/actions/runner/releases/download/${LATEST_VERSION}/actions-runner-linux-x64-${LATEST_VERSION#v}.tar.gz"; \
       elif [ "${ARCH}" = "aarch64" ]; then \
        URL="https://github.com/actions/runner/releases/download/${LATEST_VERSION}/actions-runner-linux-arm64-${LATEST_VERSION#v}.tar.gz"; \
       else \
        echo "Unsupported architecture: ${ARCH}"; \
        exit 1; \
       fi \
    && curl -o actions-runner.tar.gz -L "${URL}" \
    && tar xzf ./actions-runner.tar.gz \
    && rm actions-runner.tar.gz

# Dependencies for the runner
RUN ./bin/installdependencies.sh

# Create non-root user
RUN groupadd -r runner && useradd -r -g runner runner

# Change ownership of /actions-runner to non-root user
RUN chown -R runner:runner /actions-runner

# Switch to non-root user
USER runner

# Set environment variables
ENV REPO_URL=""
ENV TOKEN=""

# Configure and run the runner in a single CMD command
CMD ./config.sh --url ${REPO_URL} --token ${TOKEN} --unattended --replace && ./run.sh
