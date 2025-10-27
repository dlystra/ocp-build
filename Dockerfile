# Start from the minimal UBI9 image
FROM registry.redhat.io/ubi9/ubi-minimal:latest

# Copy the script into the container
COPY hello.sh /usr/local/bin/hello.sh

RUN ls && ls /usr/local/bin/

# Make the script executable
RUN chmod +x /usr/local/bin/hello.sh

# Set the script as the entrypoint
ENTRYPOINT ["/usr/local/bin/hello.sh"]
