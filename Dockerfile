# Use a minimal base image with required tools
FROM alpine:latest

# Install required packages and set up permissions in a single layer
RUN apk add --no-cache s3cmd bash && \
    mkdir -p /upload && \
    chmod +x /upload.sh

# Copy necessary files in a single step
COPY s3cfg /root/.s3cfg
COPY upload.sh /upload.sh

# Set the working directory
WORKDIR /upload

# Set the entrypoint
ENTRYPOINT ["/upload.sh"]

# docker buildx build --progress=plain --push --platform linux/amd64,linux/arm64 --tag manticoresearch/upload .