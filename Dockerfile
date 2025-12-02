# Start from the minimal UBI9 image
FROM registry.access.redhat.com/ubi9/ubi-minimal:latest

# Copy the script into the container
COPY hello.sh /usr/local/bin/hello.sh

# Make the script executable
RUN chmod +x /usr/local/bin/hello.sh

RUN microdnf -y install tree bind-utils

# Set the script as the entrypoint
ENTRYPOINT ["/usr/local/bin/hello.sh"]
